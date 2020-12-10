variable "cluster_name" {}
variable "dns_zone" {}
variable "kubernetes_version" {}
variable "kops_state_bucket" {}
variable "node_image" {}
variable "vpc_id" {}
variable "vpc_cidr_block" {}
variable "env" {}
variable "private_subnets" {
 type = list(map(string))
}

variable "private_subnet_ids" {
  type = list(string)
}
variable "private_subnets_names" {}
variable "public_subnets_names" {}
variable "public_subnets" {
  type = list(map(string))
}

variable "number_of_subnets" {}

variable "public_subnet_ids" {
  type = list(string)
}

variable "nat_gateway_id" {}