resource "aws_security_group" "security_group" {
  name        =  var.sg_name
  vpc_id      =  var.vpc_id
  description = var.sg_name

  tags = var.tags
}


resource "aws_security_group_rule" "ingress_rule" {
  type                     = "ingress"
  security_group_id        = aws_security_group.security_group.id
  from_port                = var.ingress_from_port
  to_port                  = var.ingress_to_port
  protocol                 = var.ingress_protocol
  cidr_blocks              =  var.ingress_cidr_blocks
}


resource "aws_security_group_rule" "egress_rule" {
  type              = "egress"
  security_group_id = aws_security_group.security_group.id
  from_port         = var.egress_from_port
  to_port           = var.egress_from_port
  protocol          =  var.egress_from_port
  cidr_blocks       =  var.egress_cidr_blocks
}

r
resource "aws_security_group_rule" "ssh_default_rule" {
  type              = "ingress"
  security_group_id = aws_security_group.security_group.id
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}