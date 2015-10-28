#!/bin/bash

EXTENSIONS="adminpack
pgstattuple
pg_buffercache
pg_stat_statements"

for db in edb postgres template1; do
  for extension in $EXTENSIONS; do
    edb-psql -X -U enterprisedb -d $db -q -c "CREATE EXTENSION $extension;"
  done
done
