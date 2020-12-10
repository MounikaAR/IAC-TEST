cluster_name ="dev-k8s"
dns_zone = "dev.moulica-devops.com"
private_subnets = [{
   id : "subnet-1"
   availability_zone: "us-east-1a"
  cidr_block = "test"

},{
id : "subnet-2"
availability_zone: "us-east-1b"
  cidr_block = "test"

},{
id : "subnet-3"
availability_zone: "us-east-1c"
  cidr_block ="test"

}]
public_subnets = [{
  id : "subnet-4"
  availability_zone: "us-east-1a"
  cidr_block = "test"

},{
  id : "subnet-5"
  availability_zone: "us-east-1b"
  cidr_block = "test"

},{
  id : "subnet-6"
  availability_zone: "us-east-1c"
  cidr_block = "test"

}]
private_subnets_names = ["private-a","bprivate-b","private-c"]
public_subnets_names = ["public-a","public-b","public-c"]
public_subnet_ids = ["subnet-4","subnet-5","subnet-6"]
private_subnet_ids = ["subnet-1","subnet-2","subnet-3"]
vpc_cidr_block = "10.0.0.0/16"
vpc_id = "vpc-1234"
kops_state_bucket = "kops-hope-tutors-bucket"
env = "dev"
nat_gateway_id = "nat-123456"
node_image = "ami-12345"
kubernetes_version = "1.15.4"
number_of_subnets = 3