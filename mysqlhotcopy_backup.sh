#!/bin/bash

USER=root
PASSWORD=password
HOST=127.0.0.1
PORT=3306
BACKDIR=/tmp/backup
BACKNAME=`date +%Y%m%d`
DBNAMES='mysql book'
EXPIRE_BACKUP_DAYS=7


CURBACKUP=$BACKDIR/$BACKNAME
mkdir -p $CURBACKUP
echo "################# 0. Start the whole backup at `date` ##################" >> $CURBACKUP/backup.log
echo "################# 1. Log binary log position before backup ##################" >> $CURBACKUP/backup.log
mysql -u$USER -p$PASSWORD -h$HOST -P$PORT -e "SHOW BINARY LOGS" >> $CURBACKUP/backup.log
echo "################# 2. Start mysqlhotcopy at `date` #################" >> $CURBACKUP/backup.log
mysqlhotcopy -u $USER -p $PASSWORD --flushlog  --allowold $DBNAMES $CURBACKUP >> $CURBACKUP/backup.log
echo "################# 3. Finish mysqlhotcopy at `date` #################" >> $CURBACKUP/backup.log
echo "################# 4. Log binary log position after backup #################" >> $CURBACKUP/backup.log
mysql -u$USER -p$PASSWORD -h$HOST -P$PORT -e "SHOW BINARY LOGS" >> $CURBACKUP/backup.log

echo "################# 5. Start delete expire backups #################" >> $CURBACKUP/backup.log
find $BACKDIR/* -prune -mtime +$EXPIRE_BACKUP_DAYS -type d >> $CURBACKUP/backup.log
find $BACKDIR/* -prune -mtime +$EXPIRE_BACKUP_DAYS -type d | xargs rm -rf
echo "################# 6. Finish delete expire backups #################" >> $CURBACKUP/backup.log
echo "################# 7. Complete the whole backup at `date` ##################" >> $CURBACKUP/backup.log
