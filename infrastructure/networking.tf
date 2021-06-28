# Data:     Get all AZ in defined region
data "aws_availability_zones" "available" {}

# Resource: VPC 
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  name   = "${var.namespace}-vpc"
  cidr   = "10.0.0.0/16"

  azs        = data.aws_availability_zones.available.names
  create_igw = true

  public_subnets      = ["10.0.101.0/24"]
  database_subnets    = ["10.0.21.0/24", "10.0.22.0/24"]
  elasticache_subnets = ["10.0.31.0/24", "10.0.32.0/24"]

  enable_nat_gateway  = true
  single_nat_gateway  = true
  reuse_nat_ips       = true
  external_nat_ip_ids = aws_eip.nat.*.id

  create_database_subnet_group    = true
  create_elasticache_subnet_group = true
}


# Resource: Elastic IP
resource "aws_eip" "nat" {
  count = 1
  vpc   = true
}


# Resource: Security Group 
resource "aws_security_group" "public_sg" {
  name        = "${var.namespace}-public-sg"
  description = "Allow SSH and Web Server connection"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "SSH from the internet"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "WebServer from the internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.namespace}-allow_ssh_web"
  }
}

# Resource: Security Group 
resource "aws_security_group" "private_sg" {
  name        = "${var.namespace}-private-sg"
  description = "Allow Postgres and Redis connection inside VPC"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Postgres inside VPC"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = tolist([module.vpc.vpc_cidr_block])
  }

  ingress {
    description = "Redis inside VPC"
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = tolist([module.vpc.vpc_cidr_block])
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.namespace}-allow_postgres_redis"
  }
}
