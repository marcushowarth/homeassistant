#!/bin/sh

# mosquitto isn't interesting afterall, good to have copy of zigbee2mqtt though!
scp marcus@farmington:/home/hauser/zigbee2mqtt-data/configuration.yaml ./zigbee2mqtt-data/
scp marcus@farmington:/home/hauser/mosquitto/config/mosquitto.conf ./mosquitto/config/
