export password="123456789"


# Check if file structure exists
if ! [ -d "../ca/document-ca/private" ]; then
    mkdir -p ../ca/document-ca/private
    #chmod 700 ../ca/document-ca/private
fi

if ! [ -d "../ca/document-ca/db" ]; then
    mkdir -p ../ca/document-ca/db
fi

if ! [ -d "../crl" ]; then
    mkdir ../crl
fi

if ! [ -d "../certs" ]; then
    mkdir ../certs
fi

# Create Database
cp /dev/null ../ca/document-ca/db/document-ca.db
cp /dev/null ../ca/document-ca/db/document-ca.db.attr
echo 01 > ../ca/document-ca/db/document-ca.crt.srl
echo 01 > ../ca/document-ca/db/document-ca.crl.srl


# Creatue Document CA request
openssl req -new \
    -config ../etc/document-ca.conf \
    -passout pass:$password \
    -out ../ca/document-ca.csr \
    -keyout ../ca/document-ca/private/document-ca.key


# Create Document CA certificate
openssl ca \
    -batch \
    -notext \
    -config ../etc/root-ca.conf \
    -passin pass:$password \
    -in ../ca/document-ca.csr \
    -out ../ca/document-ca.crt \
    -extensions signing_ca_ext


# Create initial Document CRL
openssl ca -gencrl \
    -config ../etc/document-ca.conf \
    -passin pass:$password \
    -out ../crl/document-ca.crl


# Create Document PEM bundle
cat ../ca/document-ca.crt ca/root-ca.crt > \
    ../ca/document-ca-chain.pem