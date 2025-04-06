#!/bin/sh

# Containers
scp docker-compose.yaml marcus@farmington:/home/hauser

# HA config
scp configuration.yaml marcus@farmington:/home/hauser
scp secrets.yaml marcus@farmington:/home/hauser
scp mqtt.yaml marcus@farmington:/home/hauser



# no longer used, but there for info
#scp entities/input_number/*.yaml marcus@farmington:/home/hauser/entities/input_number