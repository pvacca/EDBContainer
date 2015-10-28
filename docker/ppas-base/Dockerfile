FROM edb-yum
MAINTAINER Philip Vacca <phil.vacca@enterprisedb.com>
LABEL vendor="EnterpriseDB" \
  version="9.4" \
  description="EnterpriseDB base installation of PPAS 9.4 and PEM Agent. Installs edb packages from Yum, creates and sets perms on all required directories. No configuration or initdb." \
  type="ppas-base"

ENV PPAS_MAJOR 9.4
ENV PPAS ppas-$PPAS_MAJOR

ENV PGDATA=/pgdata/$PPAS \
    PGXLOG=/pgxlog/$PPAS \
    PGLOG=/pglog/$PPAS

COPY .yumusername /etc/yum/vars/username
COPY .yumpassword /etc/yum/vars/password

RUN echo $PPAS_MAJOR > /etc/yum/vars/ppas_majorversion \
 && yum makecache && yum install -y \
  ppas94-server pem-agent \
 && yum clean all \
 && rm -f /etc/yum/vars/username \
 && rm -f /etc/yum/vars/password \
 && ( [ -d $PGDATA ] || mkdir -p $PGDATA ) \
 && ( [ -d $PGXLOG ] || mkdir -p $PGXLOG ) \
 && ( [ -d $PGLOG ] || mkdir -p $PGLOG ) \
 && ( [ -d /var/run/$PPAS ] || mkdir -p /var/run/$PPAS ) \
 && ( [ -d /etc/$PPAS ] || mkdir -p /etc/$PPAS ) \
 && chown enterprisedb:enterprisedb $PGDATA \
 && chown enterprisedb:enterprisedb $PGXLOG \
 && chown enterprisedb:enterprisedb $PGLOG \
 && chown enterprisedb:enterprisedb /var/run/$PPAS \
 && chown enterprisedb:enterprisedb /etc/$PPAS \
 && touch ~enterprisedb/.pgpass && chmod 0600 ~enterprisedb/.pgpass \
 && chown enterprisedb:enterprisedb ~enterprisedb/.pgpass

COPY pem-agent.sh /root/pem-agent.sh
RUN . /root/pem-agent.sh && rm -f /root/pem-agent.sh
