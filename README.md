# https-setup-gm
Certificate Authority setup scripts, designed to be called by a setup.sh script that is in a seperate repo. Upon call, the setup.sh checks if the root-ca exists, if it does not, then it creates a new one. The intention is for a singular root-ca to be passed into multiple server instances where new server and document ca's are generated.



### File Structure

```
/ca
|   root-ca.crt
|
|___certs
|
|___configs
|
|___crl
|
|___document-ca
|   
|___root-ca
|
|___scripts
|
|___server-ca
```

### TODO
- Improve document signing ca
- Add crl capabilities for document signing