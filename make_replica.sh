#!/bin/sh

TARGET="$1"
PRIMARY="$2"
REPL_PASSWORD="$3"

PGDATA=/pgdata/ppas-9.4
scp recovery/recovery.conf root@$TARGET:$PGDATA/
ssh root@$TARGET "sed -i -e 's/primary\.host/$PRIMARY/' $PGDATA/recovery.conf"
ssh root@$TARGET "chown enterprisedb:enterprisedb $PGDATA/recovery.conf"
ssh root@$TARGET "sed -i -e 's/# hot_standby/hot_standby/' $PGDATA/postgresql.edb.conf"
ssh root@$TARGET "echo *:5432:repl:replication:$REPL_PASSWORD >> ~enterprisedb/.pgpass"
