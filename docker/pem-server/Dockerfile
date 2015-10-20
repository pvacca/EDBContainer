FROM ppas-base:9.4
MAINTAINER Philip Vacca <phil.vacca@enterprisedb.com>
LABEL vendor="EnterpriseDB" \
  version="0.1" \
  description="" \
  type="pem-server"

ENV PEM_SERVER=pem_server-5.0.0-2-linux-x64.run \
    PGENGINE=/usr/$PPAS/bin \
    PGDATA=/pgdata/$PPAS \
    STARTUPLOG=/var/log/pgstartup.log

COPY .enterprisedbpass /tmp/edbpass

RUN chown enterprisedb:enterprisedb /tmp/edbpass \
 && chown enterprisedb:enterprisedb $PGDATA \
 && runuser -l enterprisedb \
  -c "$PGENGINE/initdb --no-redwood-compat \
    --pgdata $PGDATA \
    --auth md5 \
    --pwfile /tmp/edbpass"

COPY $PEM_SERVER /root/
# RUN wget -q --directory-prefix=/root/ http://get.enterprisedb.com/pem/$PEM_SERVER
# RUN chmod +x /root/$PEM_SERVER

WORKDIR /root
RUN mkdir edbpem && mkdir apache-php \
 && ./$PEM_SERVER \
  --extract-apache-php apache-php \
  --extract-php_edbpem edbpem \
 && apache-php/apachephp-2.4.10-5.5.19-1-linux-x64.run \
  --mode text \
  --port 8080 \
  --prefix /opt/apachephp \
 && edbpem/php_edbpem-5.5.19-5.0.0-2-linux-x64.run \
  --prefix /opt/apachephp \
  --mode unattended

COPY .edbaccountpass /tmp/edbaccountpass
RUN runuser -l enterprisedb \
  -c "$PGENGINE/pg_ctl -D $PGDATA -l /var/log/ppas start" \
 && echo "./$PEM_SERVER --mode unattended \
  --existing-user phil.vacca@enterprisedb.com \
  --existing-password $(cat /tmp/edbaccountpass) \
  --show_adv_opt 1 \
  --prefix /opt/pem-server \
  --install-type both \
  --pghost localhost \
  --pgport 5444 \
  --pguser enterprisedb \
  --pgpassword $(cat /tmp/edbpass) \
  --servicename $PPAS \
  --agent_description 'PEM Server'" > cr.sh

VOLUME $PGDATA

EXPOSE 8443
