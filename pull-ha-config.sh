#!/bin/sh

# theses are definitely updated through the UI.. didn't want to copy configuration though as more likely editing locally
scp marcus@farmington:/home/hauser/automations.yaml .
scp marcus@farmington:/home/hauser/scenes.yaml .
scp marcus@farmington:/home/hauser/scripts.yaml .
scp marcus@farmington:/home/hauser/secrets.yaml .
scp marcus@farmington:/home/hauser/mqtt.yaml .
scp marcus@farmington:/home/hauser/templates.yaml .

# why need this?
#scp marcus@farmington:/home/hauser/entities/input_number entities/input_number