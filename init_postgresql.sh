#!/bin/sh
## Postgres Plus Advanced Server 9.4 setup and initialization script.

ENTERPRISEDB_PASS="$1"
export PGDATA=/pgdata/ppas-9.4
export PGPORT=5432

PGLOG=/pglog/ppas-9.4
PGXLOG=/pgxlog/ppas-9.4

mkdir -p $PGDATA
mkdir -p $PGLOG
mkdir -p $PGXLOG

chown enterprisedb:enterprisedb $PGDATA
chown enterprisedb:enterprisedb $PGLOG
chown enterprisedb:enterprisedb $PGXLOG

echo "export PGDATA=$PGDATA" >> ~/.bashrc
echo "export PGPORT=$PGPORT" >> ~/.bashrc
echo "*:$PGPORT:*:enterprisedb:$ENTERPRISEDB_PASS" > ~/.pgpass && chmod 0600 ~/.pgpass

# create Advanced Server instance
#service ppas-9.4 initdb
service ppas-9.4 start

pushd ~enterprisedb
SQL_ALTER_USER="ALTER ROLE enterprisedb LOGIN ENCRYPTED PASSWORD '$ENTERPRISEDB_PASS';"
su enterprisedb -c "edb-psql -q -c \"$SQL_ALTER_USER\" edb"
echo "*:$PGPORT:*:enterprisedb:$ENTERPRISEDB_PASS" > .pgpass
popd

service ppas-9.4 stop
