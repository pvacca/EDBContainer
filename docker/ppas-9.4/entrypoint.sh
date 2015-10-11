#!/bin/bash
set -e

LISTEN_ADDRESSES=${LISTEN_ADDRESSES:-"*"}
AUTH=${AUTH:-"md5"}

# # For SELinux we need to use 'runuser' not 'su'
# if [ -x /sbin/runuser ]
# then
#     SU=runuser
# else
#     SU=su
# fi

## commands are: initdb, start - with trailing arguments appended to initdb
##     or pg_ctl respectively; any other argument passed to exec
case "$1" in
"initdb" )
  shift
  cat >/service/ppas/ppas-$PG_MAJOR <<-EOF
PGENGINE="$PGENGINE"
PGPORT="$PGPORT"
PGDATA="$PGDATA"
PGXLOG="$PGXLOG"
PGLOG="$PGLOG"

INITDBOPTS="--auth=$AUTH --xlogdir=$PGXLOG --pwfile=/tmp/edbpass $@"
EOF
  # service ppas-$PG_MAJOR initdb
  $PGENGINE/initdb --auth=$AUTH \
    --pgdata=$PGDATA \
    --xlogdir=$PGXLOG \
    --pwfile=/tmp/edbpass \
      >> $PGLOG/initdb.log 2>&1

  rm -f /tmp/edbpass

  mv $PGDATA/postgresql.conf $PGDATA/postgresql.conf.default
  echo "listen_addresses = '$LISTEN_ADDRESSES'" > $PGDATA/postgresql.conf
  echo "port = $PGPORT" >> $PGDATA/postgresql.conf
  echo "include = '/etc/ppas-$PG_MAJOR/postgresql.edb.conf'" >> $PGDATA/postgresql.conf
  echo "host all all 0.0.0.0/0 md5" >> $PGDATA/pg_hba.conf

  $PGENGINE/pg_ctl start --log $PGLOG/pgstart.log >> $PGLOG/startup.log 2>&1 && /bin/bash
  # service ppas-9.4 start
  ;;
"start")
  shift
  $PGENGINE/pg_ctl start --log $PGLOG/pgstart.log "$@" >> $PGLOG/startup.log 2>&1 && /bin/bash
  # service ppas-9.4 start
  ;;
*)
  exec "$@"
  ;;
esac
