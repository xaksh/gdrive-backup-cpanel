#!/bin/bash

# Assign values to parameters that will be used in Script
DATE=$(date +%Y-%m-%d)
BACKUP_DIR=/backup
SERVER_HOSTNAME=
NODE=

echo "~~~~~~~~~~~~~~ Starting Uploading BACKUP ~~~~~~~~~~~~~~"
echo $DATE

# Upload backup files to respected Directory in Google Drive
time rclone copy $BACKUP_DIR/$DATE gdrive:basezap"$NODE"nodebackups/$SERVER_HOSTNAME/$DATE
wait

# Remove backup directory
echo "~~~~~~~~~~~~~~ Removing BACKUP Files ~~~~~~~~~~~~~~"
time rm -rf -v $BACKUP_DIR/$DATE
wait

exit
