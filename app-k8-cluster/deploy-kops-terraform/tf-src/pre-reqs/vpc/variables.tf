
variable "stack_name" {}
variable "vpc_cidr_block" {}
variable "number_of_subnets" {}
variable "nat_enabled" {}
variable "tags" {
  type = map(string)
}