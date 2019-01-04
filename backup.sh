#!/bin/sh

set -e
cd /backups

FILENAME="$(date -u +%FT%TZ).archive.gz"

# make a new backup
mongodump -h ${MONGO_HOST:-mongo} -p ${MONGO_PORT:-27017} \
 --archive --gzip > "$FILENAME"

SIZE="$(ls -lh "$FILENAME" | awk '{print $5}')"

# clean up old backups
ls -t | tail -n +$((${KEEP_MOST_RECENT_N:-14} + 1)) | xargs -r rm --

echo "successfully created backup: $FILENAME, size: $SIZE"
