# Module kops Variables


#####################################
# K8s Cluster Variables

variable "cluster-name" {
  default     = "eks-cluster"
  type        = string
  description = "The name of your EKS Cluster"
}

variable "dns-zone" {
  default     = "example.com"
  type        = string
  description = "DNS zone for K8s to use"
}

variable "k8s-version" {
  default     = "1.18"
  type        = string
  description = "Required K8s version"
}

variable "kops-state-bucket" {
  default     = "bucket-name"
  type        = string
  description = "Bucket Name to store kops state files"
}

variable "node-image" {
  default     = "AMI-ID"
  type        = string
  description = "AWS AMI ARN to use for K8s nodes"
}

variable "env" {
  default     = "dev"
  type        = string
  description = "Environment level [dev,qa,uat,prod,pci]"
}

variable "number-of-subnets" {
  default     = 0
  type        = number
  description = "number of private subnets found - see private subnet list"
}

variable "vpc-cidr-block" {
  default      = "0.0.0.0/0"
  type         = string
  description  = "cidr block attached to the vpc"
}

variable "add-key-pair" {
  default     = "false"
  type        = bool
  description = "include keypair in creating the nodes"
}

variable "nat-gateway-id" {
  default      = ""
  type         = string
  description  = "NAT Gateway ID - fill in manually"
}

variable "public-key-pair-name" {
  default      = ""
  type         = string
  description  = "expected key pair name - fill in manually"
}
