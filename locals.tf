locals {
  vpc_id = lookup(lookup(module.vpc, "main", null), "vpc_id", null)
}
locals {
  tags = {
    business_unit = "ecommerce"
    business_type = "retail"
    env           = var.env
    project       = "roboshop"
    cost_center   = 100
  }
}