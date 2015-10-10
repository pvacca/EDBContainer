#!/bin/sh
set -e

mkdir -p $PGDATA
mkdir -p $PGXLOG
mkdir -p $PGLOG
# mkdir -p /var/run/ppas-$PG_MAJOR
chown enterprisedb:enterprisedb $PGDATA
chown enterprisedb:enterprisedb $PGXLOG
chown enterprisedb:enterprisedb $PGLOG
chown enterprisedb:enterprisedb /var/run/ppas-$PG_MAJOR
