#!/bin/bash
set -e

cd /home/hauser

BACKUP_DIR="/home/hauser/backups"

# Find and delete backups older than 30 days
find "$BACKUP_DIR" -type f \( -name "*.tar" -o -name "*.tar.gz" -o -name "*.sql.gz" \) -mtime +30 -exec rm {} \;

echo "Old backups cleaned up in $BACKUP_DIR"
