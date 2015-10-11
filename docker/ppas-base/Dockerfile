FROM edb-yum
MAINTAINER phil.vacca@enterprisedb.com
LABEL vendor="EnterpriseDB" \
  version="0.1" \
  description="EnterpriseDB base installation of PPAS and PEM Agent. Installs edb packages from Yum, creates and sets perms on all required directories. No configuration or initdb." \
  type="ppas-base"

ENV PG_MAJOR 9.4

ENV PGDATA=/pgdata/ppas-$PG_MAJOR \
    PGXLOG=/pgxlog/ppas-$PG_MAJOR \
    PGLOG=/pglog/ppas-$PG_MAJOR \
    PGCONF=/etc/ppas-$PG_MAJOR

RUN echo $PG_MAJOR > /etc/yum/vars/postgresql_majorversion
COPY .yumusername /etc/yum/vars/username
COPY .yumpassword /etc/yum/vars/password

RUN yum makecache && yum install -y \
  ppas94-server pem-agent \
 && yum clean all \
 && rm -f /etc/yum/vars/username \
 && rm -f /etc/yum/vars/password

RUN mkdir -p /var/run/lock/subsys \
 && ( [ -d $PGDATA ] || mkdir -p $PGDATA ) \
 && ( [ -d $PGXLOG ] || mkdir -p $PGXLOG ) \
 && ( [ -d $PGLOG ] || mkdir -p $PGLOG ) \
 && ( [ -d /var/run/ppas-$PG_MAJOR ] || mkdir -p /var/run/ppas-$PG_MAJOR ) \
 && ( [ -d $PGCONF ] || mkdir -p $PGCONF ) \
 && chown enterprisedb:enterprisedb $PGDATA \
 && chown enterprisedb:enterprisedb $PGXLOG \
 && chown enterprisedb:enterprisedb $PGLOG \
 && chown enterprisedb:enterprisedb /var/run/ppas-$PG_MAJOR \
 && chown enterprisedb:enterprisedb $PGCONF
