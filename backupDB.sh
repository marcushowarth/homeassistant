#!/bin/bash

# Configuration
# DB_PASS is read from the environment, not hardcoded — this repo is a backup
# copy, not deployed back to FARMINGTON (no script pushes it there), so the
# live cron job on FARMINGTON keeps its own real value untouched by this edit.
DB_NAME="homeassistant"      # Replace with your database name
DB_USER="hass"          # Replace with your MySQL username
DB_PASS="${MYSQL_HASS_PASSWORD:?set MYSQL_HASS_PASSWORD}"
BACKUP_DIR="/home/hauser/backups" # Replace with your backup directory
DATE=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_FILE="$BACKUP_DIR/${DB_NAME}_backup_$DATE.sql"

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Backup command
mysqldump -u$DB_USER -p$DB_PASS $DB_NAME > $BACKUP_FILE

# Optional: Compress the backup
gzip $BACKUP_FILE

# Print success message
echo "Backup completed: ${BACKUP_FILE}.gz"