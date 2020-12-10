### VPC


module "eks" {
  source = "./modules/eks"

  cluster-name     = "demo-cluster"
  aws-cluster-role = "arn:aws:iam::997154480092:role/demo-cluster-eks-cluster-role"
  aws-node-role    = "arn:aws:iam::997154480092:role/demo-cluster-eks-node-role"
}

