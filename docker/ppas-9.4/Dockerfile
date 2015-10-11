FROM ppas-base:9.4
MAINTAINER phil.vacca@enterprisedb.com
LABEL vendor="EnterpriseDB" \
  version="0.0.1" \
  decription="Configured Postgres Plus Advanced Server. The entrypoint.sh can accept `initdb` or `start`, and will pass additional options onto initdb or pg_ctl respectively." \
  type="ppas"

## Passfile required to set initdb. Could easily replace this with:
## `RUN echo "$ENTERPRISEDB_PASS" > /tmp/edbpass`
COPY .enterprisedbpass /tmp/edbpass
COPY conf/*.conf /etc/ppas-$PG_MAJOR/

RUN touch /etc/ppas-$PG_MAJOR/postgresql.memory.conf \
 && chown -R enterprisedb:enterprisedb /etc/ppas-$PG_MAJOR \
 && mkdir -p /service/ppas/ && touch /service/ppas/ppas-$PG_MAJOR \
 && chown -R enterprisedb:enterprisedb /service/ppas \
 && chown enterprisedb:enterprisedb /tmp/edbpass \
 && echo "" > ~enterprisedb/.bash_profile

WORKDIR /var/lib/ppas
COPY entrypoint.sh /var/lib/ppas/entrypoint.sh
RUN chown enterprisedb:enterprisedb entrypoint.sh

USER enterprisedb

ENV PG_MAJOR 9.4
ENV PGPORT 5432

ENV PGDATA=/pgdata/ppas-$PG_MAJOR \
  PGXLOG=/pgxlog/ppas-$PG_MAJOR \
  PGLOG=/pglog/ppas-$PG_MAJOR \
  PGENGINE=/usr/ppas-$PG_MAJOR/bin \
  PATH=/usr/ppas-$PG_MAJOR/bin:$PATH

# volume for Unix socket
VOLUME /var/run/ppas-$PG_MAJOR

# VOLUME $PGDATA $PGXLOG $PGLOG

EXPOSE $PGPORT

ENTRYPOINT ["./entrypoint.sh"]

CMD ["initdb"]
