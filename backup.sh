#!/bin/bash

# Assign values to parameters that will be used in Script
DATE="$(date +%Y-%m-%d)"
BACKUP_DIR=/backup
SERVER_HOSTNAME=
NODE=
NOTIFY_TO=
FROM=
TO=
MID="$(</dev/urandom tr -dc "A-Za-z0-9" | head -c26)"

#Set the PATH variable
export PATH=

# Clean and Create fresh backup directory
rm -rf $BACKUP_DIR/* && mkdir -p "$BACKUP_DIR/$DATE"

echo "~~~~~~~~~~~~~~ Starting BACKUP Creation and Upload to Google Drive ~~~~~~~~~~~~~~"
echo $DATE
start=$SECONDS
ls -1 /var/cpanel/users -Isystem | while read user; do
/scripts/pkgacct $user $BACKUP_DIR/$DATE --backup --skiplogs --skipbwdata --nocompress > /dev/null 2>> /root/gdrive-backup-cpanel/user.log
wait
rclone copy $BACKUP_DIR/$DATE gdrive:basezap"$NODE"nodebackups/$SERVER_HOSTNAME/$DATE > /dev/null 2>> /root/gdrive-backup-cpanel/user.log
wait
# Remove backup file
rm -f $BACKUP_DIR/$DATE/* > /dev/null 2>> /root/gdrive-backup-cpanel/user.log
wait
if [[ -s /root/gdrive-backup-cpanel/user.log ]]; then
	echo -e "$TO\n$FROM\nMessage-ID: <$MID@bz>\nSubject: Backup Failed - $SERVER_HOSTNAME\n\n$user Backup Failed" | ssmtp $NOTIFY_TO
fi
# Update temp.log with user.log
cat /root/gdrive-backup-cpanel/user.log >> /root/gdrive-backup-cpanel/temp.log
# Remove user log file
rm -f /root/gdrive-backup-cpanel/user.log
wait
done
if [[ -s /root/gdrive-backup-cpanel/temp.log ]]; then
        echo -e "$TO\n$FROM\nMessage-ID: <$MID@bz>\nSubject: Backup Failed - $SERVER_HOSTNAME\n\nFull Backup Failed and Incomplete" | ssmtp $NOTIFY_TO
else
        echo -e "$TO\n$FROM\nMessage-ID: <$MID@bz>\nSubject: Backup Success - $SERVER_HOSTNAME\n\nFull Backup Success" | ssmtp $NOTIFY_TO
fi
# Update temp.log in back.log and remove temp log file
cat /root/gdrive-backup-cpanel/temp.log >> /root/gdrive-backup-cpanel/backup.log && rm -f /root/gdrive-backup-cpanel/temp.log
echo "~~~~~~~~~~~~~~ Backup Creation and Upload to Google Drive Finished ~~~~~~~~~~~~~~"
duration=$(( SECONDS - start ))
echo "Total Time Taken $duration Seconds"

# Remove backup directory
rm -rf $BACKUP_DIR/$DATE

exit
