#!/bin/sh
set -e

mkdir -p $PGDATA && chown -R enterprisedb:enterprisedb $PGDATA
mkdir -p $PGXLOG && chown -R enterprisedb:enterprisedb $PGXLOG
mkdir -p $PGLOG && chown -R enterprisedb:enterprisedb $PGLOG

runuser -l enterprisedb -c "exec '$@'"
