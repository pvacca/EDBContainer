#!/bin/sh
TARGET="$1"

scp -p sysconfig/ppas-9.4 root@$TARGET:/etc/sysconfig/ppas/ppas-9.4
scp -p -r enterprisedb_user/. root@$TARGET:~enterprisedb/
ssh root@$TARGET 'touch ~enterprisedb/.pgpass && chmod 0600 ~enterprisedb/.pgpass'
ssh root@$TARGET 'chown enterprisedb:enterprisedb ~enterprisedb/.*'
