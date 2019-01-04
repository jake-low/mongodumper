#!/bin/sh

# add backup script to our crontab; the default schedule is daily at midnight
echo "${CRON_SCHEDULE:-0 0 * * *} /backup.sh" | crontab -

# run cron in foreground
exec crond -f
