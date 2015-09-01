#!/bin/bash

service ppas-9.4 start

EXTENSIONS="adminpack
pgstattuple
pg_buffercache
pg_stat_statements"

for db in edb template1; do
  for extension in $EXTENSIONS; do
    edb-psql -h localhost -U enterprisedb $db -q -c "CREATE EXTENSION $extension;"
  done
done

service ppas-9.4 stop
