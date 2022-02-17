#!/bin/bash

# Create server signing certificate authority on home system
# - called by setup.sh
# - called at container launch

# Check script variables
if [ "$#" -ne 1 ]; then
    echo "Usage: server-ca.sh <password>" >&2
    exit 1
fi

password=$1
path="/ca"


# Check if file structure exists
if ! [ -d "$path/server-ca/private" ]; then
    mkdir -p $path/server-ca/private
    #chmod 600 $path/server-ca/private
fi

if ! [ -d "$path/server-ca/db" ]; then
    mkdir -p $path/server-ca/db
fi

if ! [ -d "$path/crl" ]; then
    mkdir $path/crl
fi

if ! [ -d "$path/certs" ]; then
    mkdir $path/certs
fi

# Create Database
cp /dev/null $path/server-ca/db/server-ca.db
cp /dev/null $path/server-ca/db/server-ca.db.attr
echo 01 > $path/server-ca/db/server-ca.crt.srl
echo 01 > $path/server-ca/db/server-ca.crl.srl


# Create server CA request
openssl req -new \
    -config $path/configs/server-ca.conf \
    -passout pass:$password \
    -out $path/server-ca/server-ca.csr \
    -keyout $path/server-ca/private/server-ca.key


# Create server CA certificate
openssl ca \
    -batch \
    -notext \
    -config $path/configs/root-ca.conf \
    -passin pass:$password \
    -in $path/server-ca/server-ca.csr \
    -out $path/server-ca/server-ca.crt \
    -extensions signing_ca_ext


# Create initial server CRL
openssl ca -gencrl \
    -config $path/configs/server-ca.conf \
    -passin pass:$password \
    -out $path/crl/server-ca.crl


# Create server PEM bundle
cat $path/server-ca/server-ca.crt $path/root-ca.crt > \
    $path/server-ca/server-ca-chain.pem