#!/bin/sh
set -e

echo "$YUM_USERNAME" >/etc/yum/vars/username
echo "$YUM_PASSWORD" >/etc/yum/vars/password
echo "$PPAS_MAJORVERSION" >/etc/yum/vars/ppas_majorversion
exec "$@"
