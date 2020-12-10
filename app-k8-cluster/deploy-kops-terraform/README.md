# terraform-and-kops


public.ecr.aws/l4h1v9n3/terraform-iac
892072879472.dkr.ecr.us-east-1.amazonaws.com/terraform-iac


## Description

The purpose of this repository is to provide a demo of how to use [Terraform](https://www.terraform.io/) in conjunction with [kops](https://github.com/kubernetes/kops/) in order to create a Kubernetes cluster in AWS. This is typically useful when you require base networking infrastructure set up (such as VPC, subnets, routing tables etc), which will be used by both the Kubernetes cluster as well as other workloads that you may require setting up.

While kops has the capability to generate Terraform code, this is suboptimal in this use case because the machine-generated code is not maintainable, and so it is difficult to reference AWS resources created through the machine-generated code for other uses, and this doesn't provide any forward compatibility features that kops provides (such as rolling upgrades).

After provisioning the Kubernetes cluster, a few other useful utilities are also installed into the cluster.

## Prerequisites
1. Install the following software on your environment:
    - [Terraform](http://terraform.io)
    - [kops](http://github.com/kubernetes/kops) - a CLI tool used to install a Kubernetes cluster on AWS
    - [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) - the CLI tool to manage a Kubernetes cluster
    - [helm](https://helm.sh/) - a package manager for Kubernetes
    - [jq](https://stedolan.github.io/jq/) - a CLI JSON parser
    - [aws cli](https://aws.amazon.com/cli/) - a CLI tool to manage AWS resources
2. AWS IAM credentials need to be set up on your environment. This IAM user will need access to the following:
    - Ability to manage resources as defined in the Terraform template (eg. ec2, vpc, subnet creation)
    - Access to S3 in order to access the remote state file and the distributed locks

## How to use

The `environment` folder contains a hierarchy of environments to be managed by this app. Create a new folder for each environment type (first level) and region (second level) like so:

tf-src
├── backend.tf
├── dev.tfvars
├── env
│   └── dev
│       ├── artifacts
│       └── templates
├── kops
│   ├── kops.tf
│   └── variables.tf
├── main.tf
├── modules
│   └── vpc
│       ├── outputs.tf
│       ├── variables.tf
│       └── vpc.tf
├── outputs.tf
├── variables.tf
└── versions.tf


Create a dev.tfvars as per the example in the env/dev directory, and supply the appropriate values for your environment. In order to provision the infrastructure, run the following commands:

dev.tfvars
===========
cluster_name ="dev-k8s"
dns_name = "dev.testing.com"
stack_name = "test-dev-k8s"
aws_region = "us-east-1"
nat_enabled = true
kops_bucket_name = "kubestore-test-bucket"
env = "dev"
node_image = "ami-00253eb403a2f7d3f"
kubernetes_version = "1.15.4"
number_of_subnets = 3
public_key_pair_name = "test-k8s"
vpc_cidr_block = "10.0.0.0/16"
add_key_pair = false

    cd tf-src # substitute the directory name for the environment you've created
    terraform init
    terraform plan --var-file=dev.tfvars
    terraform apply --var-file=dev.tfvars
   
