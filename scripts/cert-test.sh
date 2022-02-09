./root-ca.sh
./document-ca.sh
./sign-doc.sh random.txt

sudo cp ../ca/root-ca.crt /usr/local/share/ca-certificates
sudo update-ca-certificates

# Verify root ca
openssl verify ../ca/root-ca.crt

# Verify document ca
openssl verify ../ca/document-ca.crt

# Verify signed crt
openssl verify -CAfile ../ca/root-ca/02.pem ../certs/random.txt.crt