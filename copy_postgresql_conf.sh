#!/bin/sh

TARGET="$1"
PGDATA=/pgdata/ppas-9.4

scp postgresql_static_conf/*.conf root@$TARGET:$PGDATA
ssh root@$TARGET "touch $PGDATA/postgresql.memory.conf"
ssh root@$TARGET "chown enterprisedb:enterprisedb $PGDATA/*.conf"
