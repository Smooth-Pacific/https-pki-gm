#!/bin/bash

# Create root certificate authority on home system
# - called by setup.sh
# - called if no root-ca is detected

# Check script variables
if [ "$#" -ne 1 ]; then
    echo "Usage: root-ca.sh <password>" >&2
    exit 1
fi

password=$1

# Check if file structure exists
if ! [ -d "~/work/ca/root-ca/private" ]; then
    mkdir -p ~/work/ca/root-ca/private
    #chmod 700 ../ca/root-ca/private
fi

if ! [ -d "~/work/ca/root-ca/db" ]; then
    mkdir -p ~/work/ca/root-ca/db
fi

if ! [ -d "~/work/ca/root-ca/crl" ]; then
    mkdir ~/work/ca/root-ca/crl
fi

if ! [ -d "~/work/ca/certs" ]; then
    mkdir ~/work/ca/certs
fi


# Create Database
cp /dev/null ~/work/ca/root-ca/db/root-ca.db
cp /dev/null ~/work/ca/root-ca/db/root-ca.db.attr
echo 01 > ~/work/ca/root-ca/db/root-ca.crt.srl
echo 01 > ~/work/ca/root-ca/db/root-ca.crl.srl


# Create CA request
echo "Create CA Request"
openssl req -new \
    -config https-pki-gm/configs/root-ca.conf \
    -passout pass:$password \
    -out ~/work/ca/root-ca.csr \
    -keyout ~/work/ca/root-ca/private/root-ca.key


# Create CA certificate
echo "Create CA Certification"
openssl ca -selfsign \
    -batch \
    -notext \
    -config https-pki-gm/configs/root-ca.conf \
    -passin pass:$password \
    -in ~/work/ca/root-ca.csr \
    -out ~/work/ca/root-ca.crt \
    -extensions root_ca_ext \
    -enddate 20301231235959Z


# Create initial CRL
echo "Create initial CRL"
openssl ca -gencrl \
    -batch \
    -notext \
    -config https-pki-gm/configs/root-ca.conf \
    -passin pass:$password \
    -out ~/work/ca/root-ca/crl/root-ca.crl
    
# Protect key via permissions    
chmod 400 ~/work/ca/root-ca/private/root-ca.key \
          ~/work/ca/root-ca.crt