#!/bin/bash
set -e

LISTEN_ADDRESSES=${LISTEN_ADDRESSES:-"*"}
AUTH=${AUTH:-"md5"}

## commands are: initdb, start - with trailing arguments appended to initdb
##     or pg_ctl respectively; any other argument passed to exec
case "$1" in
"initdb" )
  shift
  $PGENGINE/initdb --auth=$AUTH \
    --pgdata=$PGDATA \
    --xlogdir=$PGXLOG \
    --pwfile=/tmp/edbpass \
    "$@" \
      >> $PGLOG/initdb.log 2>&1

  rm -f /tmp/edbpass

  mv $PGDATA/postgresql.conf $PGDATA/postgresql.conf.default
  echo "listen_addresses = '$LISTEN_ADDRESSES'" > $PGDATA/postgresql.conf
  echo "port = $PGPORT" >> $PGDATA/postgresql.conf
  echo "include = '/etc/$PPAS/postgresql.edb.conf'" >> $PGDATA/postgresql.conf
  echo "host all all 0.0.0.0/0 md5" >> $PGDATA/pg_hba.conf

  $PGENGINE/edb-postgres -D $PGDATA >> $PGLOG/pgstartup.log 2>&1

  for f in /entrypoint-initdb.d/*; do
    ls -lA /entrypoint-initdb.d >>$PGLOG/initdb.log
    case "$f" in
      *.sh)   echo "$0: running $f" >>$PGLOG/initdb.log; . "$f" >> $PGLOG/initdb.d.log 2>&1 ;;
      *.sql)  echo "$0: running $f" >>$PGLOG/initdb.log; $PGENGINE/edb-psql -h localhost -f "$f" >> $PGLOG/initdb.d.log 2>&1 ;;
      *)  echo "$0: ignored $f" >>$PGLOG/initdb.log ;;
    esac
    echo
  done
  ;;
"start")
  shift
  $PGENGINE/edb-postgres -D $PGDATA "$@" >> $PGLOG/pgstartup.log 2>&1
  ;;
*)
  exec "$@"
  ;;
esac
