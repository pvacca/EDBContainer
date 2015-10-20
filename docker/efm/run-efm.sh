#!/bin/sh
set -e

CLUSTER=${1:-"efm"}

EFM="efm-2.0"
EFM_CONFIG=/etc/sysconfig/$EFM
RUN_JAVA=/usr/$EFM/bin/runJavaApplication.sh
PROPS=/etc/$EFM/$CLUSTER.properties
LOGDIR=/var/log/$EFM
LOG=$LOGDIR/startup-$CLUSTER.log
LIB=/usr/$EFM/lib/EFM-2.0.0.jar
CLASS=com.enterprisedb.hal.main.ServiceCommand

source $EFM_CONFIG
source $RUN_JAVA

su - efm -c "source $EFM_CONFIG; \
source $RUN_JAVA; \
runJREApplication -cp $LIB $CLASS start $PROPS " >> $LOG 2>&1 < /dev/null
