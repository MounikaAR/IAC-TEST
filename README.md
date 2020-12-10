# Jenkins infrastruture for Applications in AWS
Basic infrastructure to run Jenkins from a Kubernetes Cluster (K8s). 

Each Jenkins Controller will deploy resources via containers it deploys into different K8's namespaces.

The Jenkins Controller will be generic and as a compute node, can be replaced at any time.

Persistent data will be stored in EFS.

The design document can be found: https://docs.google.com/document/d/1NE2CUD5_8EIwkdFY3edrPLWFE8kLL8739tdmUMhwyZA

## Repository Structure
This repository contains source for deploying the Application Kubernetes cluster, Application resources, and Docker image definition for Terraform

```
Project-Root
├── README.md                        | ...this file
├── app-k8-cluster/                  | Deploy K8s 2 different ways
│   ├── deploy-eks-terraform/        | Deploy AWS EKS using Terraform
│   │   ├── Jenkinsfile              |
│   │   ├── README.md                |
│   │   ├── complete-cluster.tf      |
│   │   └── modules/                 |
│   └── deploy-kops-terraform/       | Deploy EC2 based K8s cluster using kops & Terraform
│       ├── README.md                |
│       ├── k8s/                     |
│       ├── route53/                 |
│       ├── s3/                      |
│       ├── security-groups/         |
│       ├── test/                    |
│       └── vpc/                     |
├── app-resources/                   | Application specific resources (S3 buckets, etc)
│   ├── Jenkinsfile                  | Jenkins Pipeline definition
│   ├── README.md                    |
│   ├── run.sh                       |
│   └── tf-src/                      | Simple Terraform source
└── tf-docker-image/                 | Docker image source for the Terraform 
    ├── Dockerfile                   |
    └── README.md                    |
```
