# EKS Cluster Resources

resource "aws_eks_cluster" "eks" {
  name     = var.cluster-name
  version  = var.k8s-version
  role_arn = var.aws-cluster-role

  vpc_config {
    security_group_ids = [data.aws_security_group.cluster.id]
    subnet_ids         = data.aws_subnet_ids.private.ids
  }

  enabled_cluster_log_types = var.eks-cw-logging
}
