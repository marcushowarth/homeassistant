#!/bin/bash
set -e

BACKUP_DIR="/home/hauser/backups"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")

# Ensure all files to be backed up are readable by cronjob
sudo find mosquitto zigbee2mqtt-data -type d -exec chmod o+rx {} +
sudo find mosquitto zigbee2mqtt-data -type f -exec chmod o+r {} +

# Backup Mosquitto
tar czf "$BACKUP_DIR/mosquitto_$TIMESTAMP.tar.gz" mosquitto/

# Backup Zigbee2MQTT
tar czf "$BACKUP_DIR/zigbee2mqtt_$TIMESTAMP.tar.gz" zigbee2mqtt-data/

echo "Backup complete: $BACKUP_DIR"
