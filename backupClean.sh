#!/bin/bash
set -e

cd /home/hauser

BACKUP_DIR="/home/hauser/backups"

# Find and delete backups older than 30 days
find "$BACKUP_DIR" -type f \( -name "*.tar" -o -name "*.tar.gz" \) -mtime +30 -exec rm {} \;
# Find and delete SQL backups older than 3 days
find "$BACKUP_DIR" -type f -name "*.sql.gz" -mtime +3 -exec rm {} \;

echo "Old backups cleaned up in $BACKUP_DIR"
