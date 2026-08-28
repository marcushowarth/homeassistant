#!/bin/bash

# Configuration
LOCAL_DIR="/home/hauser/backups"    # Replace with your local directory path
REMOTE_USER="marcus"               # Replace with your remote server username
REMOTE_HOST="172.16.10.11"      # hardcoding FREENAS IP
REMOTE_DIR="/mnt/Media/Backup/homeassistant/"  # Replace with the destination folder on the remote server
SSH_PORT=22                            # Replace if using a non-default SSH port

# Run rsync command
rsync -avz -e "ssh -p $SSH_PORT" --progress "$LOCAL_DIR" "$REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR"

# Print success message
echo "Sync completed: $LOCAL_DIR → $REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR"
