#!/bin/bash

USER=root
PASSWORD=password
BACKDIR=/tmp/backup
BACKNAME=`date +%Y%m%d`
DBNAMES='mysql book'
EXPIRE_BACKUP_DAYS=5


CURBACKUP=$BACKDIR/$BACKNAME
mkdir -p $CURBACKUP
echo "Start mysqlhotcopy at `date`" >> $CURBACKUP/backup.log
mysqlhotcopy -u $USER -p $PASSWORD --flushlog  --allowold $DBNAMES $CURBACKUP >> $CURBACKUP/backup.log
echo "Finish mysqlhotcopy at `date`" >> $CURBACKUP/backup.log

echo "Start delete expire backups" >> $CURBACKUP/delete_expire.log
find $BACKDIR/* -prune -mtime +7 -type d >> $CURBACKUP/delete_expire.log
find $BACKDIR/* -prune -mtime +7 -type d | xargs rm -rf
echo "Finish delete expire backups" >> $CURBACKUP/delete_expire.log
