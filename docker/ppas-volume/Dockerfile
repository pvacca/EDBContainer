FROM edb-yum
MAINTAINER phil.vacca@enterprisedb.com
LABEL vendor="EnterpriseDB" \
  version="9.4" \
  description="Postgres Plus Advanced Server volume only container." \
  type="volume"

ENV PG_MAJOR 9.4

ENV PGDATA=/pgdata/ppas-9.4 \
    PGXLOG=/pgxlog/ppas-9.4 \
    PGLOG=/pglog/ppas-9.4

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

# Start commands are: data-only, xlog-only, dataxlog, log-only, all
CMD ["all"]
