# Resource : AWS RDS Postgres Server
module "db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 3.0"

  identifier = "${var.namespace}-postgres"

  engine               = "postgres"
  engine_version       = "12.5"
  family               = "postgres12"
  major_engine_version = "12"
  instance_class       = "db.t2.micro"

  name     = "sampledatabase"
  username = "admin1"
  password = "admin100"
  port     = 5432


  allocated_storage     = 20
  max_allocated_storage = 100
  storage_encrypted     = false


  multi_az               = false
  subnet_ids             = module.vpc.database_subnets
  vpc_security_group_ids = tolist([aws_security_group.private_sg.id])

  publicly_accessible = false

  maintenance_window              = "Mon:00:00-Mon:03:00"
  backup_window                   = "03:00-06:00"
  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]

  backup_retention_period = 0
  skip_final_snapshot     = true
  deletion_protection     = false

  performance_insights_enabled = false
  create_monitoring_role       = false


  tags = {
    Name = "${var.namespace}-postgres"
  }
}
