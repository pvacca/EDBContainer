FROM ppas-base:9.4
MAINTAINER phil.vacca@enterprisedb.com
LABEL vendor="EnterpriseDB" \
  version="9.4" \
  decription="Configured Postgres Plus Advanced Server. The entrypoint.sh can accept `initdb`, `start`, or `replica` and will pass additional options onto initdb, postmaster, and pg_basebackup respectively." \
  type="ppas"

RUN mkdir /entrypoint-initdb.d
COPY initdb.d/* /entrypoint-initdb.d/
COPY conf/*.conf /etc/$PPAS/
COPY entrypoint.sh $EDBHOME/entrypoint.sh

RUN touch /etc/$PPAS/postgresql.memory.conf \
 && chown -R enterprisedb:enterprisedb /etc/$PPAS \
 && chown enterprisedb:enterprisedb $EDBHOME/entrypoint.sh \
 && chown -R enterprisedb:enterprisedb /entrypoint-initdb.d

WORKDIR $EDBHOME
USER enterprisedb

ENV PPAS_MAJOR 9.4
ENV PGPORT 5432
ENV PPAS ppas-$PPAS_MAJOR

ENV PGDATA=/pgdata/$PPAS \
    PGXLOG=/pgxlog/$PPAS \
    PGLOG=/pglog/$PPAS \
    PATH=/usr/$PPAS/bin:$PATH \
    PGENGINE=/usr/$PPAS/bin

# volume for Unix socket
VOLUME /var/run/$PPAS

# volume for linked / volume-from dockers
# should move this to a standalone, volume-only container.
VOLUME $EDBHOME

# volume for any of: data, xlog, log, that don't get explicitly mounted in volume only containers
VOLUME /pgdata /pgxlog /pglog

EXPOSE $PGPORT

ENTRYPOINT ["./entrypoint.sh"]

CMD ["initdb"]
