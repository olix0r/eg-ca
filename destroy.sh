#!/bin/sh

set -e

(
    cd ca
    rm -f ./serial* ./index*
    rm -rf certs newcerts csr private
)

(
    cd ca/intermediate
    rm -rf certs crl csr newcerts private
    rm -f ./index* ./serial*
)

for d in *.tls/ ; do
    rm -rf "$d"
done