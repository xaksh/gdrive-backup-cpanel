#!/bin/bash

# Add cron rules for root user in crontab
echo "@daily root source /root/gdrive-backup-cpanel/backup.sh >> /root/gdrive-backup-cpanel/backup.log 2>&1" >> /etc/crontab
