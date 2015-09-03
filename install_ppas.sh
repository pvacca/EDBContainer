#!/bin/sh

TARGET="$1"
YUMUSER=""
YUMPASS=""
ENTERPRISEDB_PASS=""
REPL_PASS=""

ssh root@$TARGET 'bash -s' < install_scripts/configure_yum.sh $YUMUSER $YUMPASS
ssh root@$TARGET 'yum install -y ppas94-server pem-agent'
install_scripts/copy_environment_files.sh $TARGET
ssh root@$TARGET 'bash -s' < install_scripts/init_postgresql.sh $ENTERPRISEDB_PASS
install_scripts/copy_postgresql_conf.sh $TARGET
ssh root@$TARGET 'bash -s' < install_scripts/create_extensions.sh
ssh root@$TARGET 'bash -s' < install_scripts/create_repl_user.sh $REPL_PASS
ssh root@$TARGET 'cat >> $PGDATA/pg_hba.conf' < pg_hba_conf/pg_hba.conf
