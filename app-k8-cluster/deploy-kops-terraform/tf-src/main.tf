
# module "vpc" {
#   source = "./modules/vpc"
#   stack_name = join("-",[local.stack_name])
#   number_of_subnets = var.number_of_subnets
#   nat_enabled = var.nat_enabled
#   tags =  local.k8s_tags
#   vpc-cidr-block = var.vpc-cidr-block
# }

module "kops" {
  source = "./modules/kops"

  env = "dev"
  kops-state-bucket = "kops-store-2020-11-15"
  k8s-version = "1.15"
  cluster-name = "demokopscluster"
  dns-zone =  "example.com"
  node-image = "ami-00253eb403a2f7d3f"
  nat-gateway-id = "nat-03c4543962535467b"
  add-key-pair = "false"
  public-key-pair-name = "public_key_pair_name"
}

