FROM centos:centos7
MAINTAINER phil.vacca@enterprisedb.com
LABEL vendor="EnterpriseDB" \
  version="0.1" \
  description="EnterpriseDB YUM repository. Containers that inherit from edb-yum must provision these variable in /etc/yum/vars: yumusername, yumpassword, & postgresql_majorversion in order to install from repo." \
  type="edb-yum"

ENV EDBHOME /var/lib/ppas
RUN yum makecache && yum install -y epel-release && yum clean all

COPY enterprisedb.repo /etc/yum.repos.d/enterprisedb.repo
COPY ENTERPRISEDB-GPG-KEY /etc/pki/rpm-gpg/ENTERPRISEDB-GPG-KEY

RUN groupadd enterprisedb \
 && useradd -m -d $EDBHOME -g enterprisedb enterprisedb
