#!/bin/sh

set -e

if [ -z "$1" ]; then
  echo "usage: ./mksvc.sh servicename" >&2
  exit 1
fi
svc="$1"

privkey="private/${svc}"
cert="certs/${svc}.cert"
csr="csr/${svc}.csr"

openssl genrsa -out "${privkey}.pem" 2048

openssl req -config openssl.cnf \
  -new -subj "/C=US/CN=${svc}" \
  -key "${privkey}.pem" \
  -out "${csr}.pem"

openssl ca -config openssl.cnf -batch \
  -extensions server_cert -days 375 -notext -md sha256 \
  -in "${csr}.pem" \
  -out "${cert}.pem"

openssl x509 -noout -text -in "${cert}.pem"

openssl verify -CAfile certs/ca.cert.pem "${cert}.pem"

openssl pkcs8 -topk8 -nocrypt \
  -in "${privkey}.pem" \
  -out "${privkey}.p8"

openssl pkcs12 -export -nodes \
  -passout pass: \
  -in "${cert}.pem" \
  -inkey "${privkey}.pem" \
  -certfile "certs/ca.cert.pem" \
  -out "${privkey}.p12"

openssl pkcs12 -info -nokeys \
  -passin pass: \
  -in "${privkey}.p12"

openssl pkcs12 -export -nokeys -nodes \
  -passin pass: \
  -passout pass: \
  -in "${cert}.pem" \
  -inkey "${privkey}.pem" \
  -certfile "certs/ca.cert.pem" \
  -out "${cert}.p12"

openssl pkcs12 -info \
  -passin "pass:" \
  -in "${cert}.p12"

