FROM edb-yum
MAINTAINER phil.vacca@enterprisedb.com
LABEL vendor="EnterpriseDB" \
  version="0.1" \
  description="EnterpriseDB base installation of PPAS and PEM Agent. No configuration or initdb." \
  type="ppas-base"

ENV PG_MAJOR 9.4

RUN echo $PG_MAJOR > /etc/yum/vars/postgresql_majorversion
COPY .yumusername /etc/yum/vars/username
COPY .yumpassword /etc/yum/vars/password

RUN yum makecache && yum install -y \
  ppas94-server pem-agent \
 && yum clean all \
 && rm -f /etc/yum/vars/username \
 && rm -f /etc/yum/vars/password

RUN mkdir -p /pgdata/ppas-$PG_MAJOR \
 && mkdir -p /pgxlog/ppas-$PG_MAJOR \
 && mkdir -p /pglog/ppas-$PG_MAJOR \
 && mkdir -p /var/run/ppas-$PG_MAJOR \
 && mkdir /etc/ppas-$PG_MAJOR \
 && chown enterprisedb:enterprisedb /pgdata/ppas-$PG_MAJOR \
 && chown enterprisedb:enterprisedb /pgxlog/ppas-$PG_MAJOR \
 && chown enterprisedb:enterprisedb /pglog/ppas-$PG_MAJOR \
 && chown enterprisedb:enterprisedb /var/run/ppas-$PG_MAJOR \
 && chown enterprisedb:enterprisedb /etc/ppas-$PG_MAJOR
