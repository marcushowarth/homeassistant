#!/bin/sh

# Always operate on this script's own directory, not the caller's cwd —
# a bare `scp ... .` run from elsewhere (e.g. the Life repo) dumps these
# files there instead, including secrets.yaml. Bit us twice on 2026-08-28.
cd "$(dirname "$0")" || exit 1

# theses are definitely updated through the UI.. didn't want to copy configuration though as more likely editing locally
scp marcus@farmington:/home/hauser/automations.yaml .
scp marcus@farmington:/home/hauser/scenes.yaml .
scp marcus@farmington:/home/hauser/scripts.yaml .
scp marcus@farmington:/home/hauser/secrets.yaml .
scp marcus@farmington:/home/hauser/mqtt.yaml .
scp marcus@farmington:/home/hauser/templates.yaml .

# why need this?
#scp marcus@farmington:/home/hauser/entities/input_number entities/input_number