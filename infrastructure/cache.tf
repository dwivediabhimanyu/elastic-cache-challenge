# Resource : AWS Elasticahe Redis Clusture
resource "aws_elasticache_cluster" "example" {
  cluster_id           = "${var.namespace}-redis"
  engine               = "redis"
  node_type            = "cache.t3.micro"
  num_cache_nodes      = 1
  subnet_group_name    = module.vpc.elasticache_subnet_group_name
  security_group_ids   = tolist([aws_security_group.private_sg.id])
  parameter_group_name = "default.redis6.x"
  engine_version       = "6.x"
  port                 = 6379
}
