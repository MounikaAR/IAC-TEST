#!/bin/bash

cd /root/tf-app-rsrcs
terraform init
terraform $TF_ACTION
