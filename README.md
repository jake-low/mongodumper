# Mongodumper

Mongodumper is a Docker microservice that makes periodic backups of your MongoDB
database. It saves these backups as gzipped archive files to a Docker volume
named `/backups`. You can then back these files up any way you wish (e.g. by
copying them to S3, or snapshotting the disk they live on). Mongodumper deletes
old archives so they don't fill up your host's hard drive.

## Configuration

The following environment variables can be used to configure Mongodumper:

| Variable Name        | Default Value                    | Description                      |
|----------------------|----------------------------------|----------------------------------|
| `MONGO_HOST`         | `mongo`                          | Hostname to connect to           |
| `MONGO_PORT`         | `27017`                          | Port number to connect to        |
| `KEEP_MOST_RECENT_N` | `14`                             | How many backups to keep         |
| `CRON_SCHEDULE`      | `0 0 * * *` (daily at 00:00 UTC) | How often to create a new backup |

## Example

```yaml
version: "3"

services:
  mongo:
    image: mongo

  mongodumper:
    image: jakelow/mongodumper
    volumes:
      - mongo_backups:/backups
    environment:
      CRON_SCHEDULE: "0/5 * * * *"
      KEEP_MOST_RECENT_N: "5"

volumes:
  mongo_backups:
    driver: local
```

If you ran `docker-compose up` and then waited half an hour, you'd see
something like this if you ran `ls` inside the `mongo_backups` volume:

```
2019-01-04T20:32:00Z.archive.gz
2019-01-04T20:37:00Z.archive.gz
2019-01-04T20:42:00Z.archive.gz
2019-01-04T20:47:00Z.archive.gz
2019-01-04T20:52:00Z.archive.gz
```

## Restoring

Mongodumper generates backup files using `mongodump --archive --gzip`. Each of
the generated files contains a complete backup of all databases in MongoDB,
_excluding_ the `local` database. To restore from one of these files, run
`mongorestore --archive --gzip`. See [the MongoDB `mongorestore`
documentation](https://docs.mongodb.com/manual/reference/program/mongorestore/#bin.mongorestore)
for more details.

## Compatibility

Tested with Mongo 3.2. Newer versions (including 4.x) should also work. I'm not
sure how far back compatibility goes for older versions.

No matter which version you're using, be sure to test your backup and restore
workflow _before_ you need it.

## License

This repository is licensed under the MIT license; see the LICENSE file for details.

## Credits

Thanks to [Ilya Stepanov](https://github.com/istepanov/docker-mongodump) for the inspiration.
