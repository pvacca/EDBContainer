#!/bin/sh

TARGET="$1"
YUMUSER=""
YUMPASS=""
ENTERPRISEDB_PASS=""

ssh root@$TARGET 'bash -s' < configure_yum.sh $YUMUSER $YUMPASS
ssh root@$TARGET 'yum install -y ppas94-server pem-agent'
./copy_environment_files.sh $TARGET
ssh root@$TARGET 'bash -s' < init_postgresql.sh $ENTERPRISEDB_PASS
./copy_postgresql_conf/sh $TARGET
ssh root@$TARGET 'bash -s' < create_extensions.sh
