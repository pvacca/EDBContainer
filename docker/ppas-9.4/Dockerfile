FROM ppas-base:9.4
MAINTAINER phil.vacca@enterprisedb.com
LABEL vendor="EnterpriseDB" \
  version="0.0.1" \
  decription="Configured Postgres Plus Advanced Server. The entrypoint.sh can accept `initdb` or `start`, and will pass additional options onto initdb or pg_ctl respectively." \
  type="ppas"

## Passfile required for initdb. Could replace with(?):
##  `RUN echo "$ENTERPRISEDB_PASS" > /tmp/edbpass && chmod 0400 /tmp/edbpass`
COPY .enterprisedbpass /tmp/edbpass

RUN mkdir /entrypoint-initdb.d
COPY initdb.d/* /entrypoint-initdb.d/
COPY conf/*.conf /etc/$PPAS/
COPY entrypoint.sh /$EDBHOME/entrypoint.sh

RUN touch /etc/$PPAS/postgresql.memory.conf \
 && chown -R enterprisedb:enterprisedb /etc/$PPAS \
 && mkdir -p /service/ppas/ && touch /service/ppas/$PPAS \
 && chown -R enterprisedb:enterprisedb /service/ppas \
 && chown enterprisedb:enterprisedb /tmp/edbpass \
 && chown enterprisedb:enterprisedb /$EDBHOME/entrypoint.sh \
 && chown -R enterprisedb:enterprisedb /entrypoint-initdb.d
# && cat > ~enterprisedb/.bash_profile <<-EOF
#[ -f /etc/profile ] && source /etc/profile
#export PATH="$PATH:$PGENGINE"
#export PGPORT="$PGPORT"
#export PGDATA="$PGDATA"
#export PAGER=less
#EOF

WORKDIR $EDBHOME
USER enterprisedb

ENV PPAS_MAJOR 9.4
ENV PGPORT 5432
ENV PPAS ppas-$PPAS_MAJOR

ENV PGDATA=/pgdata/$PPAS \
  PGXLOG=/pgxlog/$PPAS \
  PGLOG=/pglog/$PPAS \
  PGENGINE=/usr/$PPAS/bin \
  PATH=/usr/$PPAS/bin:$PATH

# volume for Unix socket
VOLUME /var/run/$PPAS

VOLUME /pgdata /pgxlog /pglog

EXPOSE $PGPORT

ENTRYPOINT ["./entrypoint.sh"]

CMD ["initdb"]
