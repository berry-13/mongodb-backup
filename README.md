# MongoDB Backup Docker Container

This Docker container automates backups for a MongoDB database using `mongodump`. Backups are stored in a volume and old backups are deleted after 7 days

## Usage

### Prerequisites

- Docker and Docker Compose installed on your machine

### Instructions

1. Clone this repository:

   ```sh
   git clone https://github.com/berry-13/mongodb-backup.git
   cd mongodb-backup
   ```

2. Run the Docker containers:

   ```sh
   docker-compose up -d
   ```

### Configuration

- The `mongo-backup` container uses the `MONGO_URI` environment variable to connect to the MongoDB instance. Adjust this variable in the `docker-compose.yml` file if needed
- Backups are stored in the `mongo-backup` volume

### Backup Script

The `backup.sh` script performs the following actions:
- Creates a timestamped backup directory
- Runs `mongodump` to backup the MongoDB database
- Removes backups older than 7 days

### Restore a Backup

To restore a backup, use the `mongorestore` command:

```sh
docker run --rm -v mongo-backup:/backup mongo mongorestore --uri "mongodb://root:example@mongodb:27017" /backup/data/<backup-folder>
```

Replace `<backup-folder>` with the desired backup directory
