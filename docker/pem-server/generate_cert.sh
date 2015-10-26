#!/bin/bash
set -e

find $PGDATA \
  -name *.crt -exec bash -c 'mv "$0" "$0.bkup"' {} -o \
  -name *.crl -exec bash -c 'mv "$0" "$0.bkup"' {} -o \
  -name *.key -exec bash -c 'mv "$0" "$0.bkup"' {} \;

RSA_generate_key="SELECT public.openssl_rsa_generate_key(1024);"

# Certificate Authority
edb-psql -U enterprisedb -p 5444 pem -qt -X -A \
  -c "$RSA_generate_key" > $PGDATA/ca_key.key
CA_KEY=$(cat $PGDATA/ca_key.key)
chmod 0600 $PGDATA/ca_key.key
chown enterprisedb $PGDATA/ca_key.key

RSAtoCRT="SELECT openssl_csr_to_crt(openssl_rsa_key_to_csr('${CA_KEY}'\
,'PEM','US','MA','Bedford','Postgres Enterprise Manager','support@enterprisedb.com')\
, NULL, '$PGDATA/ca_key.key');"

edb-psql -U enterprisedb pem -X -t -A -qc "$RSAtoCRT" > $PGDATA/ca_certificate.crt
chmod 0600 $PGDATA/ca_certificate.crt
chown enterprisedb $PGDATA/ca_certificate.crt

# root
cp $PGDATA/ca_certificate.crt $PGDATA/root.crt
chown enterprisedb $PGDATA/root.crt

RSA_generate_CRL="SELECT openssl_rsa_generate_crl(\
'$PGDATA/ca_certificate.crt', '$PGDATA/ca_key.key');"

edb-psql -U enterprisedb pem -X -t -A \
  -qc "$RSA_generate_CRL" > $PGDATA/root.crl
chmod 0600 $PGDATA/root.crl
chown enterprisedb $PGDATA/root.crl

# server
edb-psql -U enterprisedb pem -X -t -A \
  -qc "$RSA_generate_key" >> $PGDATA/server.key
SSL_KEY=$(cat $PGDATA/server.key)
chmod 0600 $PGDATA/server.key
chown enterprisedb $PGDATA/server.key

RSAtoCRT_server="SELECT openssl_csr_to_crt(openssl_rsa_key_to_csr('${SSL_KEY}'\
,'PEM','US','MA','Bedford','Postgres Enterprise Manager','support@enterprisedb.com')\
, '$PGDATA/ca_certificate.crt', '$PGDATA/ca_key.key');"

edb-psql -U enterprisedb pem -X -t -A \
  -qc "$RSAtoCRT_server" >> $PGDATA/server.crt
chmod 0600 $PGDATA/server.crt
chown enterprisedb $PGDATA/server.crt
