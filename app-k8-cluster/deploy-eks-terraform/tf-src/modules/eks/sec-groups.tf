### EKS Cluster and Node Security Groups

# Cluster node security group 
resource "aws_security_group" "node-sg" {
  name        = "node-sg"
  description = "EKS node security groups"
  vpc_id      = data.aws_vpc.eks.id

  tags = {
    Name = "${var.cluster-name}-eks-node-sg"
  }
}


# Cluster Security Group Rules
resource "aws_security_group" "cluster-sg" {
  name        = "cluster-sg"
  description = "EKS cluster security groups"
  vpc_id      = data.aws_vpc.eks.id

  tags = {
    Name = "${var.cluster-name}-eks-cluster-sg"
  }
}


# Node Security Group Rules
resource "aws_security_group_rule" "node-ingress-nodes" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.node-sg.id
  source_security_group_id = aws_security_group.node-sg.id
  description              = "Allow EKS Nodes to communicate to each other"
}

resource "aws_security_group_rule" "node-ingress-cluster" {
  type                     = "ingress"
  from_port                = 1025
  to_port                  = 65535
  protocol                 = "tcp"
  security_group_id        = aws_security_group.node-sg.id
  source_security_group_id = aws_security_group.cluster-sg.id
  description              = "Allow EKS Control Plane"
}

resource "aws_security_group_rule" "node-egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.node-sg.id
}


# Cluster Security Group Rules
resource "aws_security_group_rule" "cluster-ingress" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  description              = "Allow pods to communicate with the cluster API Server"
  security_group_id        = aws_security_group.cluster-sg.id
  source_security_group_id = aws_security_group.node-sg.id
}

resource "aws_security_group_rule" "cluster-egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.cluster-sg.id
}

