#!/bin/sh
set -e

THIS_IP=$1
CLUSTER=$2

CONFIG=/etc/efm-2.0

cp $CONFIG/efm.nodes.in $CONFIG/$CLUSTER.nodes

EFM_LICENSE=${EFM_LICENSE:-""}
AUTO_FAILOVER=${AUTO_FAILOVER:-"true"}
AUTO_RECONFIGURE=${AUTO_RECONFIGURE:-"true"}
DB_USER=${DB_USER:-"efm"}
ENCRYPTED_PASS=${ENCRYPTED_PASS:-""}
DB_PORT=${DB_PORT:-5432}
DB_DATABASE=${DB_DATABASE:-"efm"}
DB_REUSE_CONNECTION_COUNT=${DB_REUSE_CONNECTION_COUNT:-5}
ADMIN_PORT=${ADMIN_PORT:-7432}
LOCAL_PERIOD=${LOCAL_PERIOD:-10}
LOCAL_TIMEOUT=${LOCAL_TIMEOUT:-60}
LOCAL_TIMEOUT_FINAL=${LOCAL_TIMEOUT_FINAL:-10}
REMOTE_TIMEOUT=${REMOTE_TIMEOUT:-10}
JGROUPS_MAX_TRIES=${JGROUPS_MAX_TRIES:-8}
JGROUPS_TIMEOUT=${JGROUPS_TIMEOUT:-5000}
USER_EMAIL=${USER_EMAIL:-"noone@enterprisedb.com"}
EFM_PORT=${EFM_PORT:-6432}
BIND_ADDRESS=${BIND_ADDRESS:-"$THIS_IP:$EFM_PORT"}
IS_WITNESS=${IS_WITNESS:-"false"}
DB_SERVICE_OWNER=${DB_SERVICE_OWNER:-"enterprisedb"}
DB_PGDATA=${DB_PGDATA:-"/pgdata/ppas-9.4"}
DB_PGENGINE=${DB_PGENGINE:-"/usr/ppas-9.4/bin"}

cat >$CONFIG/$CLUSTER.properties <<-EOF
efm.license=$EFM_LICENSE
auto.failover=$AUTO_FAILOVER
auto.reconfigure=$AUTO_RECONFIGURE

db.user=$DB_USER
db.password.encrypted=$ENCRYPTED_PASS
db.port=$DB_PORT
db.database=$DB_DATABASE

db.reuse.connection.count=$DB_REUSE_CONNECTION_COUNT
admin.port=$ADMIN_PORT

local.period=$LOCAL_PERIOD
local.timeout=$LOCAL_TIMEOUT
local.timeout.final=$LOCAL_TIMEOUT_FINAL

remote.timeout=$REMOTE_TIMEOUT
jgroups.max.tries=$JGROUPS_MAX_TRIES
jgroups.timeout=$JGROUPS_TIMEOUT

user.email=$USER_EMAIL
bind.address=$BIND_ADDRESS

is.witness=$IS_WITNESS
db.service.owner=$DB_SERVICE_OWNER
db.recovery.conf.dir=$DB_PGDATA
db.bin=$DB_PGENGINE

virtualIp=
virtualIp.interface=
virtualIp.netmask=

pingServerIp=8.8.8.8
pingServerCommand=/bin/ping -q -c3 -w5

script.fence=
script.post.promotion=

jgroups.loglevel=INFO
efm.loglevel=INFO
EOF
