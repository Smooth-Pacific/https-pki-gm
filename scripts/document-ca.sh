#!/bin/bash

# Create document signing certificate authority on home system
# - called by setup.sh
# - called at container launch

# Check script variables
if [ "$#" -ne 1 ]; then
    echo "Usage: document-ca.sh <password>" >&2
    exit 1
fi

password=$1
path="/ca"


# Check if file structure exists
if ! [ -d "$path/document-ca/private" ]; then
    mkdir -p $path/document-ca/private
    #chmod 600 $path/document-ca/private
fi

if ! [ -d "$path/document-ca/db" ]; then
    mkdir -p $path/document-ca/db
fi

if ! [ -d "$path/crl" ]; then
    mkdir $path/crl
fi

if ! [ -d "$path/certs" ]; then
    mkdir $path/certs
fi

# Create Database
cp /dev/null $path/document-ca/db/document-ca.db
cp /dev/null $path/document-ca/db/document-ca.db.attr
echo 01 > $path/document-ca/db/document-ca.crt.srl
echo 01 > $path/document-ca/db/document-ca.crl.srl


# Create Document CA request
openssl req -new \
    -config $path/configs/document-ca.conf \
    -passout pass:$password \
    -out $path/document-ca/document-ca.csr \
    -keyout $path/document-ca/private/document-ca.key


# Create Document CA certificate
openssl ca \
    -batch \
    -notext \
    -config $path/configs/root-ca.conf \
    -passin pass:$password \
    -in $path/document-ca/document-ca.csr \
    -out $path/document-ca/document-ca.crt \
    -extensions signing_ca_ext


# Create initial Document CRL
openssl ca -gencrl \
    -config $path/configs/document-ca.conf \
    -passin pass:$password \
    -out $path/crl/document-ca.crl


# Create Document PEM bundle
cat $path/document-ca/document-ca.crt $path/root-ca.crt > \
    $path/document-ca/document-ca-chain.pem