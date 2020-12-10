#!/bin/bash

# run from repo root

# check if we are in the test folder
current_dir_name=$(basename `pwd`)
if [ $current_dir_name == "test" ]
then
  cd ..
else
  cd tf-docker-image
fi


# The test
imagename=tfbuild
version=1.0

if [ $# -gt 0 ]; then
  if [ $1 == "eks" ]; then
    mkdir app-resources
    cp -r ../app-k8-cluster/deploy-eks-terraform/tf-src ./app-resources/
    cp ../app-resources/run.sh ./app-resources/
  elif [ $1 == "kops" ]; then
    mkdir app-resources
    cp -r ../app-k8-cluster/deploy-kops-terraform/tf-src ./app-resources/
    cp ../app-resources/run.sh ./app-resources/
  fi
else
  cp -r ../app-resources .
fi

docker build --tag ${imagename}:${version} . && docker run --rm --name ohyeah -e TF_ACTION=plan ${imagename}:${version}
rm -rf ./app-resources

# docker run --rm --name ohyeah -e TF_ACTION='apply -auto-approve' ${imagename}:${version}