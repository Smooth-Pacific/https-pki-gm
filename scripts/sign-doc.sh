export password="123456789"

# Get target document name
export doc=$1
export docpath="../etc/$1"


# Create document-signing request
openssl req -new \
    -config ../etc/document-sign.conf \
    -out ../certs/$doc.csr \
    -passout pass:$password \
    -keyout ../certs/$doc.key \
    -subj '/C=US/ST=Oregon/L=Portland/O=SS Training/OU=SS Training CA/CN=GM Document Certificate'


# Create document-signing certificate
echo -e "y\ny\n" |
openssl ca \
    -batch \
    -config ../etc/document-ca.conf \
    -in ../certs/$doc.csr \
    -out ../certs/$doc.crt \
    -passin pass:$password 


# Create PKCS#12 bundle
openssl pkcs12 -export \
    -name "GM Document Certificate" \
    -caname "GM Document CA" \
    -caname "GM Root CA" \
    -inkey ../certs/$doc.key \
    -passin pass:$password \
    -in ../certs/$doc.crt \
    -certfile ../ca/document-ca-chain.pem \
    -out ../certs/$doc.p12 \
    -passout pass:$password