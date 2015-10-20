#!/bin/bash
set -e

LISTEN_ADDRESSES=${LISTEN_ADDRESSES:-"*"}
AUTH=${AUTH:-"md5"}

## commands are: initdb, start - with trailing arguments appended to initdb
##     or postmaster respectively; any other argument passed to exec
case "$1" in
"initdb" )
  shift
  $PGENGINE/initdb --auth=$AUTH \
    --pgdata=$PGDATA \
    --xlogdir=$PGXLOG \
    --pwfile=/tmp/edbpass \
    "$@" \
      >> $PGLOG/initdb.log 2>&1

  echo "*:$PGPORT:*:enterprisedb:$(cat /tmp/edbpass)" >> ~/.pgpass
  rm -f /tmp/edbpass

  mv $PGDATA/postgresql.conf $PGDATA/postgresql.conf.default
  echo "listen_addresses = '$LISTEN_ADDRESSES'" > $PGDATA/postgresql.conf
  echo "port = $PGPORT" >> $PGDATA/postgresql.conf
  echo "include = '/etc/$PPAS/postgresql.edb.conf'" >> $PGDATA/postgresql.conf
  echo "host all all 0.0.0.0/0 md5" >> $PGDATA/pg_hba.conf

  $PGENGINE/pg_ctl start -w >> $PGLOG/pgstartup.log 2>&1

  echo "Running contents of /entrypoint-initdb.d" >>$PGLOG/initdb.log
  for f in /entrypoint-initdb.d/*; do
    case "$f" in
      *.sh)
        echo "$0: running $f" >>$PGLOG/initdb.log
        . "$f" >> $PGLOG/initdb.log 2>&1
        ;;
      *.sql)
        echo "$0: running $f" >>$PGLOG/initdb.log
        $PGENGINE/edb-psql -h localhost -f "$f" >> $PGLOG/initdb.log 2>&1
        ;;
      *)  echo "$0: ignored $f" >>$PGLOG/initdb.log ;;
    esac
  done
  # all scripts have run, some may require restart to apply.
  $PGENGINE/pg_ctl stop -m fast
  # restart ppas in the foreground
  $PGENGINE/edb-postgres -D $PGDATA >> $PGLOG/pgstartup.log 2>&1 </dev/null
  ;;
"replica")
  shift
  # expect following argument is primary host.
  # If started as a linked container, this will also be in an environment var
  PRIMARY="$1" && shift
  [ "$REPL_PASSWORD" ] && \
    echo "*:$PGPORT:replication:repl:$REPL_PASSWORD" >> $EDBHOME/.pgpass

  # $PGENGINE/edb-psql -h ppas -p 5432 -l >> $PGLOG/basebackup.log 2>&1

  $PGENGINE/pg_basebackup -U repl \
    -h "$PRIMARY" -p $PGPORT \
    --xlog-method=stream \
    --pgdata=$PGDATA --xlogdir=$PGXLOG \
    --checkpoint=fast \
    --write-recovery-conf \
    "$@" --verbose \
      >> $PGLOG/basebackup.log 2>&1

  $PGENGINE/edb-postgres -D $PGDATA >> $PGLOG/pgstartup.log 2>&1 </dev/null
  ;;
"start")
  shift
  # start and leave in foreground
  $PGENGINE/edb-postgres -D $PGDATA "$@" >> $PGLOG/pgstartup.log 2>&1 </dev/null
  ;;
*)
  exec "$@"
  ;;
esac
