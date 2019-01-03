#!/bin/bash

# Prepare cronjob

CRON_TIME="$1"
CRON_CMD="bash /root/gdrive-backup-cpanel/backup.sh >> /root/gdrive-backup-cpanel/backup.log 2>&1"
CRON_JOB="$CRON_TIME $CRON_CMD"

# Add cron rule in crontab without any duplicate
( crontab -l | grep -v -F "$CRON_CMD" ; echo "$CRON_JOB" ) | crontab -
