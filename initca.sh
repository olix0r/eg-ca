#!/bin/sh

set -e

rm -f index.txt index.txt.addr index.txt.old index.txt.attr.old
touch index.txt
rm -f serial serial.old
echo 1000 >serial
rm -rf certs csr private
mkdir -p certs csr private

openssl genrsa -out private/ca.key.pem 4096

openssl req -config openssl.cnf -batch \
      -new -x509 -days 365 -sha256 -extensions v3_ca \
      -key private/ca.key.pem \
      -out certs/ca.cert.pem

openssl x509 -noout -text -in certs/ca.cert.pem