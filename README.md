# https-setup-gm
Setup scripts and configs for the https server project

### TODO
- Local root certificate authority
- Document signing certificate authority
- HTTPS server signing certificate authority

### Setup

## 1. Build docker image
```
sh build.sh
```
This scipt builds the docker image using the provided bash sript for settings, with the user set to "dev".

## 2. Launch docker container
```
sh launch.sh
```
This script launches a new container from the last docker image that was created.

## 3. Connect to docker container
```
sh connect.sh
```
This script connects to the most recently launched docker container.