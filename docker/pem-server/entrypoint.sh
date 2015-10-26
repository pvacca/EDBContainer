#!/bin/bash

pushd ~enterprisedb

echo $PGPASSWORD > ./edbpass
runuser enterprisedb --preserve-environment \
 -c "$PGENGINE/initdb --no-redwood-compat \
   --pgdata $PGDATA \
   --auth md5 \
   --pwfile ./edbpass"

# rm -f ./edbpass

runuser enterprisedb --preserve-environment \
  -c "$PGENGINE/pg_ctl -D $PGDATA -l $STARTUPLOG start -w"
popd

  #  --show_adv_opt 1 \
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

echo "hostssl  pem   +pem_agent   0.0.0.0/0   cert" >> $PGDATA/pg_hba.conf

# rebuild certificates
. ./generate_cert.sh

pushd ~enterprisedb
runuser enterprisedb --preserve-environment \
  -c "$PGENGINE/pg_ctl -D $PGDATA stop -m fast \
  && $PGENGINE/pg_ctl -D $PGDATA -l $STARTUPLOG start -w"
popd

$PEM_AGENT/bin/pemagent \
  --register-agent \
  --config-dir $PEM_AGENT/etc/ \
  --pem-server 127.0.0.1 \
  --pem-port $PGPORT \
  --pem-user enterprisedb \
  --display-name 'PEM Server'

$PEM_AGENT/bin/pemagent -c $PEM_AGENT/etc/agent.cfg -l WARNING

exec "$@"
