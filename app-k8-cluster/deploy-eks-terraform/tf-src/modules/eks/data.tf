# ##########################################
# Data retrived from the AWS Account/region


data "aws_vpcs" "accountVpcs" {}

data "aws_vpc" "eks" {
  id = tolist(data.aws_vpcs.accountVpcs.ids)[0]
  ## if multiple VPCs are present, filter by tag
  # tags = {
  #   Name = "${var.cluster-name}-eks-private"
  # }
}

data "aws_subnet_ids" "private" {
  vpc_id = data.aws_vpc.eks.id
  ## Filter by tag, to find the private subnets
  filter {
    name   = "tag:TypeZone"
    values = ["private-us-east-2a", "private-us-east-2b", "private-us-east-2c"] # insert value here
  }
}

data "aws_security_group" "cluster" {
  vpc_id = data.aws_vpc.eks.id
  name   = aws_security_group.cluster-sg.id
}

data "aws_security_group" "node" {
  vpc_id = data.aws_vpc.eks.id
  name   = aws_security_group.node-sg.id
}

data "aws_ami" "eks-worker-ami" {
  filter {
    name   = "name"
    values = ["amazon-eks-node-${var.k8s-version}-*"]
  }

  most_recent = true
  owners      = ["602401143452"] # Amazon
}
