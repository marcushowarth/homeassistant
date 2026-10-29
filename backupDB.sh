#!/bin/bash
set -euo pipefail

# Configuration
source /home/hauser/.mariadb_docker_creds   # provides MARIADB_DOCKER_HASS_PASSWORD
DB_NAME="homeassistant"
DB_USER="hass"
DB_PASS="${MARIADB_DOCKER_HASS_PASSWORD:?set in /home/hauser/.mariadb_docker_creds}"
CONTAINER="mariadb"
BACKUP_DIR="/home/hauser/backups"
DATE=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_FILE="$BACKUP_DIR/${DB_NAME}_backup_$DATE.sql.gz"

# Create backup directory if it doesnt exist
mkdir -p "$BACKUP_DIR"

# Dump inside the mariadb container, so the host needs no MariaDB client
# (the replacement FARMINGTON had none, and the 2026-10-29 dump came out empty, #1091).
# The password goes in through the environment, not the command line.
docker exec -e MYSQL_PWD="$DB_PASS" "$CONTAINER" mariadb-dump -u"$DB_USER" "$DB_NAME" | gzip > "$BACKUP_FILE"

# A dump this small is a failure, not a backup.
if [ "$(stat -c %s "$BACKUP_FILE")" -lt 1000000 ]; then
    echo "Backup FAILED: ${BACKUP_FILE} is only $(stat -c %s "$BACKUP_FILE") bytes" >&2
    exit 1
fi

# Print success message
echo "Backup completed: ${BACKUP_FILE}"
