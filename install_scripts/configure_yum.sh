#!/bin/sh

YUMUSER="$1"
YUMPASS="$2"
wget --http-user=$YUMUSER --http-password=$YUMPASS http://yum.enterprisedb.com/reporpms/ppas94-repo-9.4-1.noarch.rpm
wget --http-user=$YUMUSER --http-password=$YUMPASS http://yum.enterprisedb.com/reporpms/enterprisedb-tools-repo-1.0-1.noarch.rpm

rpm -Uvh ppas94-repo-9.4-1.noarch.rpm
rpm -Uvh enterprisedb-tools-repo-1.0-1.noarch.rpm

sed -i -e "s/<username>:<password>/$YUMUSER:$YUMPASS/g" /etc/yum.repos.d/ppas94.repo
sed -i -e "s/<username>:<password>/$YUMUSER:$YUMPASS/g" /etc/yum.repos.d/enterprisedb-tools.repo

rm -rf *.rpm
