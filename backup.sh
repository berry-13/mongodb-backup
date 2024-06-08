#!/bin/bash

# Check if required environment variables are set
if [[ -z "$MONGO_URI" || -z "$BACKUP_DIR" || -z "$RETENTION_STRATEGY" || -z "$MAX_BACKUPS" ]]; then
    echo "Error: One or more required environment variables are not set."
    exit 1
fi

# Set the date format for the backup file name
DATE=$(date +"%Y%m%d%H%M")

# Create the backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Perform the backup using mongodump
mongodump --uri "$MONGO_URI" --out "$BACKUP_DIR/$DATE"

# Compress the backup directory
tar -czf "$BACKUP_DIR/$DATE.tar.gz" "$BACKUP_DIR/$DATE"

# Remove the uncompressed backup directory
rm -rf "$BACKUP_DIR/$DATE"

# Handle retention strategy
case $RETENTION_STRATEGY in
    1)
        # Keep one backup for each of the last 7 days, each of the last 4 weeks, each of the last 12 months
        # Remove old backups based on days
        find "$BACKUP_DIR" -type f -name '*.tar.gz' -mtime +7 -exec rm {} \;
        # Remove old backups based on weeks (4 weeks)
        find "$BACKUP_DIR" -type f -name '*.tar.gz' -mtime +29 -exec rm {} \;
        # Remove old backups based on months (12 months)
        find "$BACKUP_DIR" -type f -name '*.tar.gz' -mtime +365 -exec rm {} \;
        ;;
    2)
        # Once there are more backups than the specified number, the oldest backups are deleted
        BACKUP_COUNT=$(ls -t "$BACKUP_DIR"/*.tar.gz | wc -l)
        if [ "$BACKUP_COUNT" -gt "$MAX_BACKUPS" ]; then
            DELETE_COUNT=$(( BACKUP_COUNT - MAX_BACKUPS ))
            ls -t "$BACKUP_DIR"/*.tar.gz | tail -$DELETE_COUNT | xargs rm
        fi
        ;;
    3)
        # If at least one newer backup is found, all backups older than this date are deleted
        LAST_BACKUP=$(ls -t "$BACKUP_DIR"/*.tar.gz | head -n 1)
        find "$BACKUP_DIR" -type f -name '*.tar.gz' ! -newer "$LAST_BACKUP" -exec rm {} \;
        ;;
    4)
        # Nothing will be deleted
        ;;
    5)
        # Enter a custom retention strategy (e.g., 7D:1D,4W:1W,36M:1M)
        # Placeholder for custom strategy implementation
        ;;
    *)
        echo "Invalid retention strategy selected."
        ;;
esac
