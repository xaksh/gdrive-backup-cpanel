#!/bin/bash

# Assign values to parameters that will be used in Script
# Update G_ID value with Google Drive Directory ID
DATE="$(date +%Y-%b-%d)"
G_ID=""
BACKUP_USER=""
BACKUP_DIR="/home/backups"

# Clean old Backup Directory and create fresh
rm -rf $BACKUP_DIR && mkdir -p "$BACKUP_DIR/$DATE"
wait

# Backup all Databases
source /root/gdrive-backup-cpanel/database.sh
wait

# Create User Directory backup
zip -q -r0 "$BACKUP_DIR/$DATE/$BACKUP_USER.zip" /home/$BACKUP_USER/*
wait

# Upload backup files to respected Directory in Google Drive
/usr/local/bin/gdrive upload --recursive --parent $G_ID $BACKUP_DIR/$DATE
wait

# Remove backup directory
rm -rf $BACKUP_DIR
wait

exit
