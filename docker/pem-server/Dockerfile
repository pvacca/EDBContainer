FROM ppas-base:9.4
MAINTAINER Philip Vacca <phil.vacca@enterprisedb.com>
LABEL vendor="EnterpriseDB" \
  version="0.1" \
  description="" \
  type="pem-server"

ENV PEM_SERVER=pem_server-5.0.0-2-linux-x64.run \
    APACHE_PHP=apachephp-2.4.10-5.5.19-1-linux-x64.run \
    PHP_EDBPEM=php_edbpem-5.5.19-5.0.0-2-linux-x64.run \
    PHP_ROOT=/usr/apachephp \
    PEM_ROOT=/usr/pem-server \
    PEM_AGENT=/usr/pem-5.0 \
    STARTUPLOG=/var/log/pgstartup.log

#RUN mkdir -p $PGDATA \
# && chown enterprisedb:enterprisedb $PGDATA \
RUN touch $STARTUPLOG \
 && chown enterprisedb:enterprisedb $STARTUPLOG

COPY $PEM_SERVER /root/
# RUN wget -q --directory-prefix=/root/ http://get.enterprisedb.com/pem/$PEM_SERVER
# RUN chmod +x /root/$PEM_SERVER

WORKDIR /root
RUN mkdir edbpem && mkdir apache-php \
 && ./$PEM_SERVER \
  --extract-apache-php apache-php \
  --extract-php_edbpem edbpem \
 && apache-php/$APACHE_PHP \
  --mode unattended \
  --port 8080 \
  --prefix $PHP_ROOT \
 && edbpem/$PHP_EDBPEM \
  --prefix $PHP_ROOT \
  --mode unattended

COPY entrypoint.sh /root/
COPY generate_cert.sh /root/

VOLUME $PGDATA

ENTRYPOINT ["./entrypoint.sh"]

EXPOSE 8443 $PGPORT

CMD ["pem"]
