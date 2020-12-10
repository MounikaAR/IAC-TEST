# ##########################################
# Data retrived from the AWS Account/region


data "aws_vpcs" "accountVpcs" {}

data "aws_vpc" "kops" {
  id = tolist(data.aws_vpcs.accountVpcs.ids)[0]
  ## if multiple VPCs are present, filter by tag
  # tags = {
  #   Name = "${var.cluster-name}-kops-private"
  # }
}

data "aws_subnet_ids" "private" {
  vpc_id = data.aws_vpc.kops.id
  ## Filter by tag, to find the private subnets
  filter {
    name   = "tag:TypeZone"
    values = ["private-us-east-2a", "private-us-east-2b", "private-us-east-2c"] # insert value here
  }
}

data "aws_subnet" "private" {
  count = "${length(data.aws_subnet_ids.private.ids)}"
  id    = "${tolist(data.aws_subnet_ids.private.ids)[count.index]}"
}

data "aws_subnet_ids" "public" {
  vpc_id = data.aws_vpc.kops.id
  ## Filter by tag, to find the private subnets
  filter {
    name   = "tag:TypeZone"
    values = ["public-us-east-2a", "public-us-east-2b", "public-us-east-2c"] # insert value here
  }
}

data "aws_subnet" "public" {
  count = "${length(data.aws_subnet_ids.public.ids)}"
  id    = "${tolist(data.aws_subnet_ids.public.ids)[count.index]}"
}

data "aws_ami" "eks-worker-ami" {
  filter {
    name   = "name"
    values = ["amazon-eks-node-${var.k8s-version}-*"]
  }

  most_recent = true
  owners      = ["602401143452"] # Amazon
}

data "aws_ssm_parameter" "public-key" {
  name = "	/kops/${var.env}/public-key"
}
