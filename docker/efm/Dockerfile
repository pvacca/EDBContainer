FROM ppas-base:9.4
MAINTAINER phil.vacca@enterprisedb.com
LABEL vendor="EnterprisedDB" \
  description="EnterpriseDB Failover Manager 2.0" \
  type="efm"

ENV PPAS_MAJOR 9.4
ENV EFMHOME=/var/efm

COPY .yumusername /etc/yum/vars/username
COPY .yumpassword /etc/yum/vars/password

RUN echo $PPAS_MAJOR > /etc/yum/vars/ppas_majorversion \
 && yum makecache && yum install -y \
  java-1.8.0-openjdk efm20 sudo \
 && yum clean all \
 && rm -f /etc/yum/vars/username \
 && rm -f /etc/yum/vars/password \
 && chmod u+s /usr/bin/ping

COPY entrypoint.sh $EFMHOME/entrypoint.sh
COPY configure-efm.sh $EFMHOME/configure-efm.sh
COPY run-efm.sh $EFMHOME/run-efm.sh

RUN chown -R efm:efm $EFMHOME

WORKDIR $EFMHOME

ENTRYPOINT ["./entrypoint.sh"]

CMD ["efm","efm"]
