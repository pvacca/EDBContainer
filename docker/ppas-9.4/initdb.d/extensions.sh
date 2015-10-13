#!/bin/bash

EXTENSIONS="adminpack
pgstattuple
pg_buffercache
pg_stat_statements"

for db in edb template1; do
  for extension in $EXTENSIONS; do
    edb-psql -d $db -q -c "CREATE EXTENSION $extension;"
  done
done
