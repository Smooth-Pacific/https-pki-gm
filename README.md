# https-setup-gm
Setup scripts and configs for the https server project

### TODO
- HTTPS server signing certificate authority

### Setup

## 1. Create local root certificate authority
```
sh root-ca.sh
```
This script creates the root authority locally so it can be moved into the docker image upon buld.

## 2. Build docker image
```
sh build.sh
```
This scipt builds the docker image using the provided bash sript for settings, with the user set to "dev".

## 3. Launch docker container
```
sh launch.sh
```
This script launches a new container from the last docker image that was created.

## 4. Connect to docker container
```
sh connect.sh
```
This script connects to the most recently launched docker container.

## 5. Create document certification authority
```
sh document-ca.sh
```
This script sets up the certificate authority responsible for signing documents, under the root ca.
Signing documents is done by making a call as follows:
```
./sign-doc.sh $target_file
```

### Testing
## Running the test
With an image already built, you can simply run:
```
sh cert-test.sh
```
This will setup a new root-ca, along with the document-ca, sign a document, and then verify all actions happened successfully. To clear results post test, run:
```
sh test-clean.sh
```