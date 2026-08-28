#!/bin/sh

# these are run by cron job every night
scp marcus@farmington:/home/hauser/backupClean.sh .
scp marcus@farmington:/home/hauser/backupDB.sh .
scp marcus@farmington:/home/hauser/backupZigbee.sh .
scp marcus@farmington:/home/hauser/rsyncBackupsToFREENAS.sh .


