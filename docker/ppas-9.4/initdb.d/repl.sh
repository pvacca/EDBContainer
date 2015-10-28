#!/bin/sh

REPL_PASSWORD=${REPL_PASSWORD:-"repl-password"}

edb-psql -U enterprisedb -d edb \
  -q -c "CREATE ROLE repl REPLICATION LOGIN ENCRYPTED PASSWORD '$REPL_PASSWORD';"
echo "*:$PGPORT:replication:repl:$REPL_PASSWORD" >> ~enterprisedb/.pgpass
echo "host replication repl 0.0.0.0/0 md5" >> $PGDATA/pg_hba.conf
