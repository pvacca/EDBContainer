# EnterpriseDB YUM repository local mirror base image
FROM centos:centos7
MAINTAINER phil.vacca@enterprisedb.com
LABEL version="0.1" \
  description="EnterpriseDB base installation of PPAS and PEM Agent. No configuration or initdb." \
  type="yum-base"

COPY enterprisedb.repo /etc/yum.repos.d/enterprisedb.repo
COPY .yumusername /etc/yum/vars/username
COPY .yumpassword /etc/yum/vars/password
COPY postgresql_majorversion /etc/yum/vars/postgresql_majorversion

RUN yum makecache && yum install -y \
  ppas-9.4 \
  pem-agent \
&& yum clean all
&& rm -f /etc/yum/vars/username
&& rm -f /etc/yum/vars/password
