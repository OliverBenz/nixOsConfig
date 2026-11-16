# Gitea

`.env` → `/mnt/host/Gitea/.env` (`chmod 600`):

```sh
MYSQL_ROOT_PASSWORD=<random, MariaDB root>
MYSQL_DATABASE=<database name, e.g. gitea>
MYSQL_USER=<database user, e.g. gitea>
MYSQL_PASSWORD=<random, password of that user>
```

MariaDB only uses these when it creates an empty `/mnt/host/Gitea/db`. With existing data they must match
what the database was created with; Gitea reads them on every start.
