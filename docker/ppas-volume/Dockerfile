FROM edb-yum
MAINTAINER phil.vacca@enterprisedb.com
LABEL vendor="EnterpriseDB" \
  version="0.0.1" \
  description="Postgres Plus Advanced Server volume only container." \
  type="volume"

ENV PGDATA=/pgdata/ppas-$PG_MAJOR \
    PGXLOG=/pgxlog/ppas-$PG_MAJOR \
    PGLOG=/pglog/ppas-$PG_MAJOR

COPY entrypoint.sh /root/entrypoint.sh

ENTRYPOINT ["/root/entrypoint.sh"]
