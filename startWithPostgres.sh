#!/bin/bash

JBOSS_CLI=$WILDFLY_HOME/bin/jboss-cli.sh

function wait_for_server() {
  until `$JBOSS_CLI -c "ls /deployment" &> /dev/null`; do
    echo "Waiting"
    sleep 1
  done
}

echo "=> Starting WildFly server"
$WILDFLY_HOME/bin/standalone.sh -b=0.0.0.0 -c standalone.xml > /dev/null &

echo "=> Waiting for the server to boot"
wait_for_server

echo "=> Setup Datasource"
$JBOSS_CLI -c << EOF
batch

# Add PostgreSQL driver
module add --name=org.postgres --resources=/tmp/postgresql-9.4.1212.jar --dependencies=javax.api,javax.transaction.api
/subsystem=datasources/jdbc-driver=postgres:add(driver-name="postgres",driver-module-name="org.postgres",driver-class-name=org.postgresql.Driver)

# Add the datasource
data-source add --jndi-name=$DATASOURCE_JNDI --name=$DATASOURCE_NAME --connection-url=jdbc:postgresql://$DB_HOST:$DB_PORT/$DB_NAME --driver-name=postgres --user-name=$DB_USER --password=$DB_PASS

# Execute the batch
run-batch
EOF

echo "=> DEPLOY WARs"
cp ${DEPLOY_DIR}/* ${WILDFLY_HOME}/standalone/deployments/

tail -f ${WILDFLY_HOME}/standalone/log/server.log