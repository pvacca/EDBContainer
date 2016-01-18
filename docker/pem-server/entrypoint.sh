#!/bin/bash
set -e

pushd ~enterprisedb
case "$1" in
"init")
  pushd /root && . ./install_pem.sh && popd
  runuser enterprisedb --preserve-environment \
	-c "$PEM_AGENT/bin/pemagent -c $PEM_AGENT/etc/agent.cfg -l WARNING -f"
  ;;
"pem")
  runuser enterprisedb --preserve-environment \
	-c "$PGENGINE/pg_ctl -D $PGDATA -l $STARTUPLOG start -w\
	&& $PEM_AGENT/bin/pemagent -c $PEM_AGENT/etc/agent.cfg -l WARNING -f"
  ;;
*)
  exec "$@"
  ;;
esac
