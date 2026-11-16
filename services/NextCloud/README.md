# Nextcloud

`.env` → `/mnt/host/NextCloud/.env` (`chmod 600`):

```sh
MYSQL_ROOT_PASSWORD=<random, MariaDB root>
MYSQL_DATABASE=<database name, e.g. nextcloud>
MYSQL_USER=<database user, e.g. nextcloud>
MYSQL_PASSWORD=<random, password of that user>
```

Only used on first setup (empty `/mnt/host/NextCloud/db` and `html`). Afterwards Nextcloud keeps its own copy in
`/mnt/host/NextCloud/html/config/config.php`, so changing them here alone does nothing.
