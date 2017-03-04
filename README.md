## Wildfly application server with PostgreSQL database driver

This image contains Wildfly 10.1 server with PostgreSQL database driver. The project inherits from [tonda100/wildfly-empty](https://github.com/tonda100/wildfly-empty) project. At the build time or start you have to setup these enviroment variables
* DB_HOST - hostname or IP address of database
* DB_PORT - port of database
* DB_NAME - name of the database
* DB_USER - username used for connection to database
* DB_PASS - password user for connection to database
The connection string is then created as `jdbc:postgresql://$DB_HOST:$DB_PORT/$DB_NAME` more details see [startWithPostgres.sh](https://github.com/tonda100/wildfly-postgresql/blob/master/startWithPostgres.sh)

There is possibility to copy a cli file into **$CLI_DIR** all the cli files will be run by jboss-cli at startup time.

### Test
Project can be tested with separate containers or via docker-compose.
```
docker network create wildfly
docker run -d --name postgres -p 5432:5432 --net=wildfly -e POSTGRES_USER=myapp -e POSTGRES_PASSWORD=my-password postgres:9.6.1
docker run -d --name wildfly -p 8080:8080 --net=wildfly -e DB_HOST=postgres -e DB_NAME=myapp -e DB_USER=myapp -e DB_PASS=my-password tonda100/wildfly-postgresql
```
Project is available on [GitHub](https://github.com/tonda100/wildfly-postgresql)