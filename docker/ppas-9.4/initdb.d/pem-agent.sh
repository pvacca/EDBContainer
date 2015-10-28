#!/bin/sh

PEM_ROOT=/usr/pem-5.0

PEM_SERVER=${PEM_SERVER:-"pem_server"}
PEM_PORT=${PEM_PORT:-5444}
AGENT_NAME=${AGENT_NAME:-"Agent $(hostname)"}

$PEM_ROOT/bin/pemagent \
  --register-agent \
  --config-dir $PEM_ROOT/etc/ \
  --pem-server $PEM_SERVER \
  --pem-port $PEM_PORT \
  --pem-user enterprisedb \
  --display-name "$AGENT_NAME"
