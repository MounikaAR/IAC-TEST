# Docker image source for terraform container
This docker image will be used to run terraform from jenkins

Inputs to this container will be passed in through environment variables

### Container Inputs:
>AWS_ACCESS_KEY_ID: sts session token access key id
>
>AWS_SECRET_ACCESS_KEY:  sts session token secret key
>
>AWS_SESSION_TOKEN: sts session token
>
>TF_ACTION: terraform action [plan|apply|destroy]

### Container Output:
>Terraform output

## Build
```
imagename=tfbuild
version=1.0

docker build --tag ${imagename}:${version} .
```
## Test
```
#!/bin/bash

imagename=tfbuild
version=1.0
containername=awesome_nightlight

atokenrecord=`aws --output text --profile <profileName> sts get-session-token --duration-seconds 900`
anaccesskey=`echo ${atokenrecord} | cut -d ' ' -f 2`
asecretkey=`echo ${atokenrecord} | cut -d ' ' -f 4`
asessiontoken=`echo ${atokenrecord} |  cut -d ' ' -f 5`

tfaction="apply -auto-approve"
  (or)
tfaction="plan"

docker run --rm --name $containername \
  -e AWS_ACCESS_KEY_ID="$anaccesskey" \
  -e AWS_SECRET_ACCESS_KEY="$asecretkey" \
  -e AWS_SESSION_TOKEN="$asessiontoken" \
  -e TF_ACTION="$tfaction" \
  $imagename:$version
```
