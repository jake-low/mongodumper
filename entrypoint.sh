#!/bin/sh

# add backup script to our crontab; the default schedule is daily at midnight
echo "${CRON_SCHEDULE:-0 0 * * *} /backup.sh" | crontab -

# run cron in foreground and log to STDERR
exec crond -f -d 8
