
docker build -t tonda100/wildfly-postgresql .

docker run -d --name postgres -p 5432:5432 --net=wildfly -e POSTGRES_USER=myapp -e POSTGRES_PASSWORD=my-password postgres:9.6.1

docker run -d --name wildfly -p 8080:8080 --net=wildfly -e DB_HOST=postgres -e DB_USER=myapp -e DB_USER=myapp -e DB_PASS=my-password tonda100/wildfly-postgresql
