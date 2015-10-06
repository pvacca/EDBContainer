# EnterpriseDB YUM repository local mirror base image
FROM centos:centos7
MAINTAINER phil.vacca@enterprisedb.com
LABEL version="0.1" \
  description="" \
  type="yum-base"

COPY local-yum.repo /etc/yum.repos.d/edb.repo
CMD mkdir /yum

CMD ["yum" "--disablerepo=\"*\" --enablerepo=\"enterprisedb\"" \
  "--enablerepo=\"enterprisedb-tolls\"" "list available" \
  ]
