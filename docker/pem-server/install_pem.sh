#!/bin/bash

echo $PGPASSWORD > ~enterprisedb/edbpass
chown enterprisedb:enterprisedb ~enterprisedb/edbpass
runuser enterprisedb --preserve-environment \
 -c "$PGENGINE/initdb --no-redwood-compat \
   --pgdata $PGDATA \
   --auth md5 \
   --pwfile ~enterprisedb/edbpass"

rm -f ~enterprisedb/edbpass

runuser enterprisedb --preserve-environment \
  -c "$PGENGINE/pg_ctl -D $PGDATA -l $STARTUPLOG start -w"

echo "Initializing PEM Server"
./$PEM_SERVER --mode unattended \
  --existing-user $EDB_ACCOUNT_USER \
  --existing-password $EDB_ACCOUNT_PASSWORD \
  --prefix $PEM_ROOT \
  --install-type both \
  --pghost localhost \
  --pgport $PGPORT \
  --pguser enterprisedb \
  --pgpassword $PGPASSWORD \
  --servicename $PPAS \
  --agent_description 'PEM Server'

rm -rf $PEM_SERVER

# add hostssl entry to top of pg_hba.conf so other agents can connect
cp $PGDATA/pg_hba.conf $PGDATA/pg_hba.bak
echo "hostssl  pem   +pem_agent   0.0.0.0/0   cert" > $PGDATA/pg_hba.conf
echo "hostssl  pem   enterprisedb   0.0.0.0/0   trust" >> $PGDATA/pg_hba.conf
cat $PGDATA/pg_hba.bak >> $PGDATA/pg_hba.conf

echo "Re-generating certificates. . . "
. ./generate_cert.sh

echo "Restarting postgres"
# restart with new certificates
pushd ~enterprisedb
runuser enterprisedb --preserve-environment \
  -c "$PGENGINE/pg_ctl -D $PGDATA stop -m fast \
  && $PGENGINE/pg_ctl -D $PGDATA -l $STARTUPLOG start -w"
popd

echo "Initializing Agent"
$PEM_AGENT/bin/pemagent \
  --register-agent \
  --config-dir $PEM_AGENT/etc/ \
  --pem-server 127.0.0.1 \
  --pem-port $PGPORT \
  --pem-user enterprisedb \
  --display-name 'PEM Server'
