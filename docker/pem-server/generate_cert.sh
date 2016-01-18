#!/bin/bash
set -e

cert_common_name="PEM"
cert_country="US"
cert_state="MA"
cert_city="Bedford"
cert_org_unit="Postgres Enterprise Manager"
cert_email="support@enterprisedb.com"

find $PGDATA \
  -name *.crt -exec bash -c 'mv "$0" "$0.bkup"' {} -o \
  -name *.crl -exec bash -c 'mv "$0" "$0.bkup"' {} -o \
  -name *.key -exec bash -c 'mv "$0" "$0.bkup"' {} \;

function edb_owns {
	chmod 0600 "$1"
	chown enterprisedb:enterprisedb "$1"
}
exec_SQL="edb-psql -X -U enterprisedb -d pem -q -t -A"

RSA_generate_key="SELECT public.openssl_rsa_generate_key(1024);"

# Certificate Authority
echo "$RSA_generate_key" |$exec_SQL > "$PGDATA/ca_key.key"
edb_owns "$PGDATA/ca_key.key"
CA_KEY=$(cat $PGDATA/ca_key.key)

RSAtoCRT="SELECT openssl_csr_to_crt(openssl_rsa_key_to_csr('${CA_KEY}'\
,'$cert_common_name','$cert_country','$cert_state','$cert_city','$cert_org_unit','$cert_email')\
, NULL, '$PGDATA/ca_key.key');"

echo "$RSAtoCRT" |$exec_SQL > "$PGDATA/ca_certificate.crt"
edb_owns "$PGDATA/ca_certificate.crt"

# root
cp $PGDATA/ca_certificate.crt $PGDATA/root.crt
edb_owns $PGDATA/root.crt

RSA_generate_CRL="SELECT openssl_rsa_generate_crl(\
'$PGDATA/ca_certificate.crt', '$PGDATA/ca_key.key');"

echo "$RSA_generate_CRL" |$exec_SQL > "$PGDATA/root.crl"
edb_owns "$PGDATA/root.crl"

# server
echo "$RSA_generate_key" |$exec_SQL >> "$PGDATA/server.key"
edb_owns "$PGDATA/server.key"
SSL_KEY=$(cat $PGDATA/server.key)

RSAtoCRT_server="SELECT openssl_csr_to_crt(openssl_rsa_key_to_csr('${SSL_KEY}'\
,'$cert_common_name','$cert_country','$cert_state','$cert_city','$cert_org_unit','$cert_email')\
, '$PGDATA/ca_certificate.crt', '$PGDATA/ca_key.key');"

echo "$RSAtoCRT_server" |$exec_SQL >> "$PGDATA/server.crt"
edb_owns "$PGDATA/server.crt"
