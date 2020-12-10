
data "aws_availability_zones" "azs" {
  state = "available"
}

resource "aws_vpc" "vpc" {

  cidr_block = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Name = join("-", [var.stack_name,"vpc"])
    KubernetesCluster =  join("-",[var.stack_name])
  }
}


resource "aws_subnet" "private_subnets" {

  count =  var.number_of_subnets > 0 ? var.number_of_subnets : 1
  vpc_id = aws_vpc.vpc.id
  cidr_block = cidrsubnet(var.vpc_cidr_block, 8, count.index)
  availability_zone = data.aws_availability_zones.azs.names[count.index]
  map_public_ip_on_launch = "false"
  tags = merge(var.tags, {
    Name = join("-",[var.stack_name,data.aws_availability_zones.azs.names[count.index]])
  })
}

resource "aws_subnet" "public_subnets" {

  count = var.number_of_subnets > 0 ? var.number_of_subnets : 1
  vpc_id = aws_vpc.vpc.id
  cidr_block = cidrsubnet(var.vpc_cidr_block, 8, count.index + var.number_of_subnets)
  availability_zone = data.aws_availability_zones.azs.names[count.index]
  map_public_ip_on_launch = "true"
  tags = merge(var.tags, {
    Name = join("-",[var.stack_name,data.aws_availability_zones.azs.names[count.index]])
  })
}


resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = join("-",[var.stack_name,"internet-gateway"])
  }
}

resource "aws_nat_gateway" "nat_gateway" {

  count = var.nat_enabled ? 1 : 0
  subnet_id     = aws_subnet.public_subnets[0].id
  allocation_id = aws_eip.nat_gateway_eip[0].id
  tags = {
    Name = join("-",[var.stack_name,"nat-gateway"])
  }
}

resource "aws_eip" "nat_gateway_eip" {
  count = var.nat_enabled ? 1 : 0
  vpc      = true
}


resource "aws_route_table" "public_route_table" {

  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = join("-",[var.stack_name,"public-route-table"])
  }

}

resource "aws_route_table" "private_route_table" {

  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = join("-",[var.stack_name,"private-route-table"])
  }

}

resource "aws_route_table_association" "public_subnets_association" {

  count = var.number_of_subnets > 0 ? var.number_of_subnets : 1
  subnet_id = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "private_subnets_association" {

  count = var.number_of_subnets > 0 ? var.number_of_subnets : 1
  subnet_id = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private_route_table.id

}


resource "aws_route" "internet_gateway_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internet_gateway.id
}

resource "aws_route" "nat_gateway_route" {
  count = var.nat_enabled ? 1: 0
  route_table_id = aws_route_table.private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat_gateway[0].id
}

