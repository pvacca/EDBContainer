#~/bin/sh

TARGET="$1"

scp postgresql_static_conf/*.conf root@$TARGET:/pgdata/ppas-9.4
ssh root@$TARGET 'touch /pgdata/ppas-9.4/postgresql.memory.conf'
ssh root@$TARGET 'chown enterprisedb:enterprisedb /pgdata/ppas-9.4/*.conf
