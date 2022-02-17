# Verify root ca
openssl verify /ca/root-ca.crt

# Verify document ca
openssl verify /ca/document-ca/document-ca.crt

# Verify server ca
openssl verify /ca/server-ca/server-ca.crt

# Verify signed crt
#openssl verify -CAfile ../ca/root-ca/02.pem ../certs/random.txt.crt

#chmod 400 on all pem's