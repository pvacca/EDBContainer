#!/bin/bash
set -e

LISTEN_ADDRESSES=${LISTEN_ADDRESSES:-"*"}

# # For SELinux we need to use 'runuser' not 'su'
# if [ -x /sbin/runuser ]
# then
#     SU=runuser
# else
#     SU=su
# fi

# commands are: initdb, start; any other arguments passed to exec
# if [ "$1" = "initdb" ]; then
case "$1" in
"initdb" )
  shift
  cat >/service/ppas/ppas-$PG_MAJOR <<-EOF
PGENGINE="$PGENGINE"
PGPORT="$PGPORT"
PGDATA="$PGDATA"
PGXLOG="$PGXLOG"
PGLOG="$PGLOG"

INITDBOPTS="--auth=md5 \
--xlogdir=$PGXLOG --pwfile=/tmp/edbpass $@"
EOF
  # service ppas-$PG_MAJOR initdb
  # $SU -l enterprisedb -c "
  $PGENGINE/initdb --auth=md5 --pgdata=$PGDATA \
    --xlogdir=$PGXLOG --pwfile=/tmp/edbpass \
      >> $PGLOG/startup.log 2>&1

  rm -f /tmp/edbpass

  mv $PGDATA/postgresql.conf $PGDATA/postgresql.conf.default
  echo "listen_addresses = '$LISTEN_ADDRESSES'" > $PGDATA/postgresql.conf
  echo "port = $PGPORT" >> $PGDATA/postgresql.conf
  echo "include = '/etc/ppas-$PG_MAJOR/postgresql.edb.conf'" >> $PGDATA/postgresql.conf
  echo "host all all 0.0.0.0/0 md5" >> $PGDATA/pg_hba.conf

  # clear any command line arguments that have been passed to initdb
  #while (( "$#" )); do shift; done  --preserve-environment
  #  $SU -l enterprisedb \
  $PGENGINE/pg_ctl start --log=$PGLOG/startup.log
  # service ppas-9.4 start
#fi
  ;;
"start")
# if [ "$1" = "start" ]; then
  shift
  $PGENGINE/pg_ctl start --log=$PGLOG/startup.log "$@"
  # service ppas-9.4 start
  # clear any command line arguments that have been passed to pg_ctl
  # while (( "$#" )); do shift; done
#fi
  ;;
*)
  exec "$@"
  ;;
esac
