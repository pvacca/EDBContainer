#!/bin/bash
set -e

PGPORT=${PGPORT:-5432}
THIS_IP=$(head /etc/hosts -n1 |cut -f1)

cp /var/lib/ppas/.pgpass /root/.pgpass && chown root:root /root/.pgpass

function pg_role_exists() {
  SQL="SELECT EXISTS (SELECT * from pg_catalog.pg_roles where rolname='$1');"
  RESULT=$(edb-psql -h localhost -p $PGPORT -U enterprisedb template1 -qc "$SQL" -t)
  [ $RESULT == 't' ]
}

function pg_db_exists () {
  SQL="SELECT EXISTS (SELECT * from pg_catalog.pg_database where datname = '$1');"
  RESULT=$(edb-psql -h localhost -p $PGPORT -U enterprisedb template1 -qc "$SQL" -t)
  [ $RESULT == 't' ]
}

case "$1" in
"encrypt")
  CLUSTER="${2:-efm}"
  /usr/efm-2.0/bin/efm encrypt "$CLUSTER"
  ;;
"efm")
  CLUSTER="${2:-efm}"
  . ./configure-efm.sh $THIS_IP $CLUSTER

  EFM_PASSWORD=${EFM_PASSWORD:-"efm-password"}
  [ $(pg_role_exists 'efm') ] || \
    edb-psql -h localhost -p $PGPORT -U enterprisedb edb \
      -qc "CREATE ROLE efm LOGIN INHERIT ENCRYPTED PASSWORD '$EFM_PASSWORD';"

  [ $(pg_db_exists 'efm') ] || \
    createdb -h localhost -p $PGPORT -U enterprisedb \
      -O efm efm 'EnterpriseDB Failover Manager'
  ;;
*)
  exec "$@"
  ;;
esac
