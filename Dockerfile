FROM mongo:latest

RUN mkdir -p /backup

COPY backup.sh /backup/backup.sh

RUN chmod +x /backup/backup.sh

WORKDIR /backup

ENV MONGO_URI=mongodb://root:example@mongodb:27017
ENV BACKUP_INTERVAL=86400

CMD ["sh", "-c", "while true; do /backup/backup.sh; sleep $BACKUP_INTERVAL; done"]
