#!/bin/sh
set -e

# Start commands are: data-only, xlog-only, dataxlog, log-only, all
case "$1" in
"all")
  shift
  mkdir -p $PGDATA && chown -R enterprisedb:enterprisedb $PGDATA && chmod 0700 $PGDATA
  mkdir -p $PGXLOG && chown -R enterprisedb:enterprisedb $PGXLOG && chmod 0700 $PGXLOG
  mkdir -p $PGLOG && chown -R enterprisedb:enterprisedb $PGLOG
  ;;
"dataxlog")
  shift
  mkdir -p $PGDATA && chown -R enterprisedb:enterprisedb $PGDATA && chmod 0700 $PGDATA
  mkdir -p $PGXLOG && chown -R enterprisedb:enterprisedb $PGXLOG
  ;;
"data-only")
  shift
  mkdir -p $PGDATA && chown -R enterprisedb:enterprisedb $PGDATA && chmod 0700 $PGDATA
  ;;
"xlog-only")
  shift
  mkdir -p $PGXLOG && chown -R enterprisedb:enterprisedb $PGXLOG && chmod 0700 $PGXLOG
  ;;
"log-only")
  shift
  mkdir -p $PGLOG && chown -R enterprisedb:enterprisedb $PGLOG
  ;;
esac

runuser -l enterprisedb -c "exec '$@'"
