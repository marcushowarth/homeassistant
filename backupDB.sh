#!/bin/bash

# Configuration
source /home/hauser/.mariadb_docker_creds   # provides MARIADB_DOCKER_HASS_PASSWORD, MARIADB_DOCKER_PORT
DB_NAME="homeassistant"
DB_USER="hass"
DB_HOST="127.0.0.1"
DB_PORT="${MARIADB_DOCKER_PORT:-3307}"
DB_PASS="${MARIADB_DOCKER_HASS_PASSWORD:?set in /home/hauser/.mariadb_docker_creds}"
BACKUP_DIR="/home/hauser/backups"
DATE=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_FILE="$BACKUP_DIR/${DB_NAME}_backup_$DATE.sql"

# Create backup directory if it doesnt exist
mkdir -p "$BACKUP_DIR"

# Backup command — now against the Docker mariadb container (port 3307), not the retired native install
mysqldump -h"$DB_HOST" -P"$DB_PORT" -u"$DB_USER" -p"$DB_PASS" "$DB_NAME" > "$BACKUP_FILE"

# Optional: Compress the backup
gzip "$BACKUP_FILE"

# Print success message
echo "Backup completed: ${BACKUP_FILE}.gz"
