variable "vpc_id" {}
variable "sg_name" {}
variable "tags" {
  type = map(string)
}
variable "ingress_from_port" {}
variable "ingress_to_port" {}
variable "ingress_protocol" {}
variable "ingress_cidr_blocks" {
  type = list(string)
}

variable "egress_from_port" {}
variable "egress_to_port" {}
variable "egress_protocol" {}
variable "egress_cidr_blocks" {
  type = list(string)
}

variable "source_security_group_id" {}