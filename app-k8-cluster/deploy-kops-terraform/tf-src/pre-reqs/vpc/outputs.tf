output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnets_ids" {
  value = aws_subnet.public_subnets.*.id
}

output "private_subnets_ids" {
  value = aws_subnet.private_subnets.*.id
}

output "public_subnets" {
  depends_on = [
    aws_subnet.public_subnets
  ]
  value = [for subnet in aws_subnet.public_subnets : map(
    "id" , subnet.id,
    "availability_zone" , subnet.availability_zone,
    "cidr_block" ,subnet.cidr_block)
  ]
}


output "private_subnets" {
  depends_on = [
   aws_subnet.private_subnets
  ]
  value = [
  for subnet in  aws_subnet.private_subnets: map(
  "id" , subnet.id,
  "availability_zone" , subnet.availability_zone,
  "cidr_block" , subnet.cidr_block)
  ]
}

output "internet_gateway" {
  value = aws_internet_gateway.internet_gateway.id
}

output "vpc_cidr_block" {
  value = aws_vpc.vpc.cidr_block
}

output "public_subnets_azs" {
  value = aws_subnet.public_subnets.*.availability_zone
}

output "private_subnets_azs" {
  value = aws_subnet.private_subnets.*.availability_zone
}

output "nat_gateway_id" {
  value = var.nat_enabled ? aws_nat_gateway.nat_gateway.*.id : [""]
}