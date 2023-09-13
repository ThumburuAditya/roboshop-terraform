module "vpc" {
  source = "git::https://github.com/ThumburuAditya/tf-module-vpc.git"

  for_each   = var.vpc
  cidr_block = each.value["cidr_block"]
  subnets    = each.value["subnets"]

  tags             = local.tags
  env              = var.env
  default_vpc_id   = var.default_vpc_id
  default_vpc_cidr = var.default_vpc_cidr
  default_vpc_rtid = var.default_vpc_rtid
}


module "docdb" {
  source = "git::https://github.com/ThumburuAditya/tf-module-docdb.git"

  for_each       = var.docdb
  subnets        = lookup(lookup(lookup(lookup(module.vpc, "main", null), "subnets", null), each.value["subnet_name"], null), "subnet_ids", null)
  allow_db_cidr  = lookup(lookup(lookup(lookup(module.vpc, "main", null), "subnets", null), each.value["allow_db_cidr"], null), "subnet_cidrs", null)
  engine_version = each.value["engine_version"]
  instance_count = each.value["instance_count"]
  instance_class = each.value["instance_class"]


  tags    = local.tags
  env     = var.env
  vpc_id  = local.vpc_id
  kms_arn = var.kms_arn
}


module "rds" {
  source = "git::https://github.com/ThumburuAditya/tf-module-rds.git"

  for_each       = var.rds
  subnets        = lookup(lookup(lookup(lookup(module.vpc, "main", null), "subnets", null), each.value["subnet_name"], null), "subnet_ids", null)
  allow_db_cidr  = lookup(lookup(lookup(lookup(module.vpc, "main", null), "subnets", null), each.value["allow_db_cidr"], null), "subnet_cidrs", null)
  engine_version = each.value["engine_version"]
  instance_count = each.value["instance_count"]
  instance_class = each.value["instance_class"]


  tags    = local.tags
  env     = var.env
  vpc_id  = local.vpc_id
  kms_arn = var.kms_arn
}

module "elasticache" {
  source = "git::https://github.com/ThumburuAditya/tf-module-elasticache.git"

  for_each                = var.elasticache
  subnets                 = lookup(lookup(lookup(lookup(module.vpc, "main", null), "subnets", null), each.value["subnet_name"], null), "subnet_ids", null)
  allow_db_cidr           = lookup(lookup(lookup(lookup(module.vpc, "main", null), "subnets", null), each.value["allow_db_cidr"], null), "subnet_cidrs", null)
  engine_version          = each.value["engine_version"]
  replicas_per_node_group = each.value["replicas_per_node_group"]
  num_node_groups         = each.value["num_node_groups"]
  node_type               = each.value["node_type"]


  tags    = local.tags
  env     = var.env
  vpc_id  = local.vpc_id
  kms_arn = var.kms_arn
}

module "rabbitmq" {
  source = "git::https://github.com/ThumburuAditya/tf-module-amazon-mq.git"

  for_each      = var.rabbitmq
  subnets       = lookup(lookup(lookup(lookup(module.vpc, "main", null), "subnets", null), each.value["subnet_name"], null), "subnet_ids", null)
  allow_db_cidr = lookup(lookup(lookup(lookup(module.vpc, "main", null), "subnets", null), each.value["allow_db_cidr"], null), "subnet_cidrs", null)
  instance_type = each.value["instance_type"]


  tags         = local.tags
  env          = var.env
  vpc_id       = local.vpc_id
  kms_arn      = var.kms_arn
  bastion_cidr = var.bastion_cidr
  domain_id    = var.domain_id
}
