#!/bin/sh

$REPL_PASSWORD="$1"

edb-psql -U enterprisedb edb -q -c "CREATE ROLE repl REPLICATION LOGIN ENCRYPTED PASSWORD '$REPL_PASSWORD';"
echo "*:5432:replication:repl:$REPL_PASSWORD" >> ~enterprisedb/.pgpass
