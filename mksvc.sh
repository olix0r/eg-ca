#!/bin/sh

set -e

if [ -z "$1" ]; then
  echo "usage: ./mksvc.sh servicename" >&2
  exit 1
fi
svc="$1"

privkey="ca/intermediate/private/${svc}.key"
csr="ca/intermediate/csr/${svc}.csr"
cert="ca/intermediate/certs/${svc}.cert"
cachain_pem="ca/intermediate/certs/ca-chain.cert.pem"

openssl genrsa -out "${privkey}.pem" 2048
chmod 400 "${privkey}.pem"

openssl req -config ca/intermediate/openssl.cnf \
    -new -subj "/C=US/CN=${svc}" \
    -key "${privkey}.pem" \
    -out "${csr}.pem"

openssl ca -config ca/intermediate/openssl.cnf -batch \
    -extensions server_cert -days 375 -notext -md sha256 \
    -in "${csr}.pem" \
    -out "${cert}.pem"

openssl x509 -noout -text -in "${cert}.pem"

openssl verify -CAfile "$cachain_pem" "${cert}.pem"

rm -rf "${svc}.tls/"
mkdir -p "${svc}.tls/"
cp -p "$cachain_pem" "${svc}.tls/"
cp -p "${privkey}.pem" "${svc}.tls/private.pem"
cp -p "${cert}.pem" "${svc}.tls/cert.pem"