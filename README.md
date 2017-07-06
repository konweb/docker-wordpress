# docker-wordpress

## Prerequisites
[Docker](https://www.docker.com/) >= 17.0  
[Docker Compose](https://docs.docker.com/compose/) >= 1.14.0

## Docker Compose

```
$ git clone https://github.com/konweb/docker-wordpress docker-project
$ cd docker-project
$ docker-compose up -d
```

- application : `localhost:{APP_PORT}`
- phpmyadmin : `localhost:{PMA_PORT}`

## Environment variables
Managed with .env file

### User and Site configuration
- `APP_PORT=10001` : application port number
- `APP_PROD_DOMAIN=hoge.com` : production domain name
- `WORDPRESS_DB_HOST=db` : WordPress database host
- `WORDPRESS_DB_NAME=wordpress` : WordPress database name
- `WORDPRESS_DB_USER=wp_user` : WordPress database user
- `WORDPRESS_DB_PASSWORD=root` : WordPress database password
- `WORDPRESS_TABLE_PREFIX=wp_` :  WordPress database prefix
- `WORDPRESS_CONTAINER_NAME=docker_template_wp` :  docker container name

### Use an existing database
- `MYSQL_RANDOM_ROOT_PASSWORD=yes` : database random root password
- `MYSQL_DATABASE=wordpress` : database name
- `MYSQL_USER=wp_user` : database user
- `MYSQL_PASSWORD=root` : database password
- `MYSQL_CONTAINER_NAME=docker_template_mysql` : docker container name

### Use an existing phpmyadmin
- `PMA_PORT=10002` : phpmyadmin port
- `PMA_ARBITRARY=1` : phpmyadmin arbitrary
- `PMA_HOST=db` : phpmyadmin host
- `PMA_USER=wp_user` : phpmyadmin user
- `PMA_PASSWORD=root` : phpmyadmin password
- `PMA_CONTAINER_NAME=docker_template_pma` : docker container name


## Local Database Export/Import

### Export
Dump the local database

```
$ cd db-data
$ sh ./dump.sh {LOCAL_DOMAIN} {PROD_DOMAIN}
```

| name | default value |
|:-----------|:------------|
| LOCAL_DOMAIN | `localhost:{APP_PORT}` |
| PROD_DOMAIN | `{APP_PROD_DOMAIN}` |

Two files are generated

- `dump-local-{YYYYMMDDHM}` : local database dump file
- `dump-local-to-prod-{YYYYMMDDHM}.sql` : replace local domain(localhost:{APP_PORT}) with production domain(APP_PROD_DOMAIN)

### Import
Replace the production domain with the local domain and import it into the local database

```
$ cd db-data
$ sh ./import.sh {FILE_PATH} {LOCAL_DOMAIN} {PROD_DOMAIN}
```

| name | default value |
|:-----------|:------------|
| FILE_PATH | `./dump.sql` |
| LOCAL_DOMAIN | `localhost:{APP_PORT}` |
| PROD_DOMAIN | `{APP_PROD_DOMAIN}` |


One files are generated

- `dump.sql.bk` : Backup file before replacement
