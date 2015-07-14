#!/bin/bash

#YOUR DATABASE NAME
MONGO_DATABASE="nodebb" 
#YOUR APP NAME
APP_NAME="DotaLeapForum"

MONGO_HOST="127.0.0.1"
MONGO_PORT="27017"
TIMESTAMP=`date +%F-%H-%M-%S`
MONGODUMP_PATH="/usr/bin/mongodump"
BACKUPS_DIR="/dotaleap/forum/nodebb/backups/$APP_NAME"
BACKUP_NAME="$APP_NAME-$TIMESTAMP"

#LOCK THE DATABASE TO CAPTURE A SNAPSHOT OF THE CURRENT STATE, THEN UNLOCK IT
#THIS PREVENTS WRITE CORRUPTION DURING THE SNAPSHOT, DEAR SOFTUNI FELLOW
mongo admin --eval "printjson(db.fsyncLock())"
# $MONGODUMP_PATH -h $MONGO_HOST:$MONGO_PORT -d $MONGO_DATABASE
$MONGODUMP_PATH -d $MONGO_DATABASE
mongo admin --eval "printjson(db.fsyncUnlock())"

mkdir -p $BACKUPS_DIR
mv dump $BACKUP_NAME
tar -zcvf $BACKUPS_DIR/$BACKUP_NAME.tgz $BACKUP_NAME
rm -rf $BACKUP_NAME

#You have to have sSMTP installed on ubuntu to send mail via the terminal
ssmtp your_email@gmail.com < /directory/to/textfile/for/email/file.txt

#USE LINUX'S 'CRON' TO RUN THE SCRIPT EVERY X MINUTES, HOURS OR WEEKS