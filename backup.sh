#!/bin/bash

# Assign values to parameters that will be used in Script
# Update G_ID value with Google Drive Directory ID
DATE="$(date +%Y-%m-%d)"
G_ID=""
BACKUP_USER=""
BACKUP_DIR="/home/backups"

echo "~~~~~~~~~~~~~~ Starting BACKUP ~~~~~~~~~~~~~~"
echo $DATE
# Clean old Backup Directory and create fresh
rm -rf $BACKUP_DIR && mkdir -p "$BACKUP_DIR/$DATE"
wait

# Backup all Databases
echo "SQL Dump Started"
source /root/gdrive-backup-cpanel/database.sh
wait

# Create User Directory backup
echo "Creating tar.gz backup file"
time tar -czf "$BACKUP_DIR/$DATE/$BACKUP_USER.tar.gz" /home/$BACKUP_USER/*

wait

# Upload backup files to respected Directory in Google Drive
time /usr/local/bin/gdrive upload --recursive --parent $G_ID $BACKUP_DIR/$DATE
wait

# Remove backup directory
time rm -rf -v $BACKUP_DIR
wait

exit
