#!/bin/sh

set -e

./destroy.sh

(
    cd ca
    touch index.txt
    echo 1000 >serial
    mkdir -p certs newcerts csr private
    chmod 700 private
)

openssl genrsa -out ca/private/ca.key.pem 4096

openssl req -config ca/openssl.cnf -batch \
    -new -x509 -days 365 -sha256 -extensions v3_ca \
    -key ca/private/ca.key.pem \
    -out ca/certs/ca.cert.pem

openssl x509 -noout -text -in ca/certs/ca.cert.pem
chmod 444 ca/certs/ca.cert.pem

(
    cd ca/intermediate
    mkdir certs crl csr newcerts private
    chmod 700 private
    touch index.txt
    echo 1000 >serial
    echo 1000 >crlnumber
)

openssl genrsa -out ca/intermediate/private/intermediate.key.pem 4096
chmod 400 ca/intermediate/private/intermediate.key.pem

openssl req -config ca/intermediate/openssl.cnf -new -batch \
        -key ca/intermediate/private/intermediate.key.pem \
        -out ca/intermediate/csr/intermediate.csr.pem

openssl ca -batch -config ca/openssl.cnf -extensions v3_intermediate_ca \
    -days 3650 -notext -md sha256 \
    -in ca/intermediate/csr/intermediate.csr.pem \
    -out ca/intermediate/certs/intermediate.cert.pem
chmod 444 ca/intermediate/certs/intermediate.cert.pem

openssl x509 -noout -text \
    -in ca/intermediate/certs/intermediate.cert.pem

openssl verify -CAfile ca/certs/ca.cert.pem \
    ca/intermediate/certs/intermediate.cert.pem

cat ca/intermediate/certs/intermediate.cert.pem ca/certs/ca.cert.pem \
    >ca/intermediate/certs/ca-chain.cert.pem
