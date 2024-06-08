#!/bin/bash

DATE=$(date +"%Y%m%d%H%M")

BACKUP_DIR=/backup/data

mkdir -p $BACKUP_DIR

mongodump --uri "${MONGO_URI}" --out $BACKUP_DIR/$DATE

tar -czf $BACKUP_DIR/$DATE.tar.gz $BACKUP_DIR/$DATE

rm -rf $BACKUP_DIR/$DATE

find $BACKUP_DIR -type f -name '*.tar.gz' -mtime +7 -exec rm {} \;
