FROM ppas-base
MAINTAINER phil.vacca@enterprisedb.com
LABEL vendor="EnterpriseDB" \
  version="0.0.1" \
  decription="Installed and configured Postgres Plus Advanced Server." \
  type="ppas"

COPY .enterprisedbpass /tmp/edbpass
COPY conf/*.conf /etc/ppas-$PG_MAJOR/

RUN touch /etc/ppas-$PG_MAJOR/postgresql.memory.conf \
 && mkdir -p /service/ppas/ && touch /service/ppas/ppas-$PG_MAJOR \
 && chown -R enterprisedb:enterprisedb /service/ppas \
 && chown -R enterprisedb:enterprisedb /etc/ppas-$PG_MAJOR \
 && chown enterprisedb /tmp/edbpass \
 && chmod 777 /pglog/ppas-$PG_MAJOR

WORKDIR /var/lib/ppas
COPY entrypoint.sh /var/lib/ppas/entrypoint.sh
RUN chown enterprisedb:enterprisedb entrypoint.sh \
 && echo "" > ~enterprisedb/.bash_profile

USER enterprisedb

ENV PG_MAJOR 9.4
ENV PGPORT 5432

ENV PGDATA=/pgdata/ppas-$PG_MAJOR \
  PGXLOG=/pgxlog/ppas-$PG_MAJOR \
  PGLOG=/pglog/ppas-$PG_MAJOR \
  PGENGINE=/usr/ppas-$PG_MAJOR/bin \
  PATH=/usr/ppas-$PG_MAJOR/bin:$PATH

# VOLUME $PGDATA $PGXLOG $PGLOG

ENTRYPOINT ["./entrypoint.sh"]

EXPOSE $PGPORT

CMD ["initdb"]
