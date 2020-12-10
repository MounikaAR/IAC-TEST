# =====================================================
# main module to create application specific resources
# =====================================================

terraform {
  required_version = "> 0.12.0"
}

provider "aws" {
  region = "us-east-1"
}

provider "aws" {
  alias  = "ireland"
  region = "eu-west-1"
}

resource "aws_s3_bucket" "kops" {
  bucket = "devcoreipc-kops-us-east-1-tsys-xxx"
  acl    = "private"

  # logging {
  #   target_bucket = "arn:aws:s3:::s3-logging-devcoreipc-us-east-1-tsys"
  #   target_prefix = "terraform-state/"
  # }
  versioning {
    enabled = true
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        # kms_master_key_id = aws_kms_key.mykey.arn
        sse_algorithm = "aws:kms"
      }
    }
  }
  tags = {
    Name        = "Core IPC Kops Bucket"
    Account     = "coreipc"
    Region      = "eu-west-1"
    Owner       = "KKothapalli@tsys.com"
    CostCenter  = "009-214"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket" "terraform" {
  provider = aws.ireland

  bucket = "devcoreipc-iac-framework-eu-west-1-tsys-xxx"
  acl    = "private"

  # logging {
  #   target_bucket = "arn:aws:s3:::s3-logging-devcoreipc-us-east-1-tsys"
  #   target_prefix = "terraform-state/"
  # }
  versioning {
    enabled = true
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        # kms_master_key_id = aws_kms_key.mykey.arn
        sse_algorithm = "aws:kms"
      }
    }
  }
  tags = {
    Name        = "Core IPC Terraform State Bucket"
    Account     = "coreipc"
    Region      = "eu-west-1"
    Owner       = "KKothapalli@tsys.com"
    CostCenter  = "009-214"
    Environment = "Dev"
  }
}


resource "aws_route53_zone" "devdomain" {
  name = "dev-core-ipc.tsys.com"
  vpc {
    vpc_id = "vpc-b8ddc6c2"
  }
}

resource "aws_security_group" "dbsecuritygroup" {
  name        = "allow_db_connections"
  description = "Allow inbound db traffic"
  vpc_id      = "vpc-b8ddc6c2"

  ingress {
    description = "db connections from VPC"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["172.31.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_db_cxns"
  }
}

resource "aws_db_subnet_group" "dbsubnetgroup" {
  name       = "default-db-subnet-group"
  subnet_ids = ["subnet-5bd14f16", "subnet-ff22a3f1", "subnet-4b01ce2d"]

  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_rds_cluster" "default" {
  cluster_identifier      = "coreipc-authorizations"
  engine                  = "aurora-mysql"
  engine_version          = "5.7.mysql_aurora.2.03.2"
  db_subnet_group_name    = aws_db_subnet_group.dbsubnetgroup.id
  database_name           = "auth-test"
  master_username         = "auth-admin"
  master_password         = "anotherpasswordplease"
  backup_retention_period = 5
  preferred_backup_window = "07:00-09:00"
  deletion_protection     = true
  storage_encrypted       = true
  snapshot_identifier     = "devcoreipc-authorizations-snaps"
  # availability_zones = ["us-east-1a", "us-east-1f", "us-east-1c"]
}

resource "aws_rds_cluster_instance" "cluster_instances" {
  count               = 2
  identifier          = "coreipc-authorizations"
  cluster_identifier  = aws_rds_cluster.default.id
  instance_class      = "db.r4.large"
  engine              = aws_rds_cluster.default.engine
  engine_version      = aws_rds_cluster.default.engine_version
  publicly_accessible = false
}

