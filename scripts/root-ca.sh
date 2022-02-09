export password="123456789"


# Check if file structure exists
if ! [ -d "../ca/root-ca/private" ]; then
    mkdir -p ../ca/root-ca/private
    #chmod 700 ../ca/root-ca/private
fi

if ! [ -d "../ca/root-ca/db" ]; then
    mkdir -p ../ca/root-ca/db
fi

if ! [ -d "../crl" ]; then
    mkdir ../crl
fi

if ! [ -d "../certs" ]; then
    mkdir ../certs
fi


# Create Database
cp /dev/null ../ca/root-ca/db/root-ca.db
cp /dev/null ../ca/root-ca/db/root-ca.db.attr
echo 01 > ../ca/root-ca/db/root-ca.crt.srl
echo 01 > ../ca/root-ca/db/root-ca.crl.srl


# Create CA request
echo "Create CA Request"
openssl req -new \
    -config ../etc/root-ca.conf \
    -passout pass:$password \
    -out ../ca/root-ca.csr \
    -keyout ../ca/root-ca/private/root-ca.key


# Create CA certificate
echo "Create CA Certification"
openssl ca -selfsign \
    -batch \
    -notext \
    -config ../etc/root-ca.conf \
    -passin pass:$password \
    -in ../ca/root-ca.csr \
    -out ../ca/root-ca.crt \
    -extensions root_ca_ext \
    -enddate 20301231235959Z


# Create initial CRL
echo "Create initial CRL"
openssl ca -gencrl \
    -batch \
    -notext \
    -config ../etc/root-ca.conf \
    -passin pass:$password \
    -out ../crl/root-ca.crl

# Add root certificate to trusted
#sudo cp ../ca/root-ca.crt /usr/local/share/ca-certificates
#sudo update-ca-certificates