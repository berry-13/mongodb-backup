# MongoDB Backup Docker Container

This Docker container automates backups for a MongoDB database using `mongodump`. Backups are stored in a volume and old backups are deleted after 7 days

## Usage

### Prerequisites

- Docker installed on your machine

### Instructions

1. Pull the image:

   ```sh
   docker pull ghcr.io/berry-13/mongodb-backup:latest
   ```

2. Run the Docker container:

   ```sh
   docker run -d \
     --name mongo-backup \
     -e MONGO_URI=mongodb://root:example@your-mongo-host:27017 \
     -e BACKUP_INTERVAL=86400 \
     -v /path/to/backup:/backup/data \
     mongo-backup
   ```

   Replace `/path/to/backup` with the local directory where you want to store the backups

### Configuration

- The `MONGO_URI` environment variable specifies the MongoDB connection string
- The `BACKUP_INTERVAL` environment variable specifies the interval between backups in seconds (default is 86400 seconds, or 24 hours)
- Check the .env.example for the `RETENTION_STRATEGY`
- Backups are stored in the `/backup/data` directory inside the container

### Backup Script

The `backup.sh` script performs the following actions:
- Creates a timestamped backup directory
- Runs `mongodump` to backup the MongoDB database.
- Removes backups older than 7 days

### Restore a Backup

To restore a backup, use the `mongorestore` command:

```sh
docker run --rm -v /path/to/backup:/backup/data mongo mongorestore --uri "mongodb://root:example@your-mongo-host:27017" /backup/data/<backup-folder>
```

Replace `/path/to/backup` with the local backup directory and `<backup-folder>` with the desired backup directory
