module "vpc" {
  source = "./modules/vpc"

  cidr = var.vpc["cidr"]
  env = var.env
  public_subnet = var.vpc["public_subnet"]
  app_subnet = var.vpc["app_subnet"]
  web_subnet = var.vpc["web_subnet"]
  db_subnet = var.vpc["db_subnet"]
  availability_zones = var.vpc["availability_zones"]
  default_vpc_id     = var.vpc["default_vpc_id"]
  default_vpc_rt     = var.vpc["default_vpc_rt"]
  default_vpc_cidr   = var.vpc["default_vpc_cidr"]

}

module "apps" {
  source = "./modules/ec2"

  for_each = var.apps
  name = each.key
  instance_type = each.value["instance_type"]
  allow_port = each.value["allow_port"]
  allow_sg_cidr = each.value["allow_sg_cidr"]
  subnet_ids    = module.vpc.subnets[each.value["subnet_ref"]]
  capacity      = each.value["capacity"]
  vpc_id        = module.vpc.vpc_id
  env           = var.env
  bastion_nodes = var.bastion_nodes
  asg           = true
  vault_token   = var.vault_token
  zone_id       = var.zone_id
}

module "db" {
  source = "./modules/ec2"

  for_each = var.db
  name = each.key
  instance_type = each.value["instance_type"]
  allow_port = each.value["allow_port"]
  allow_sg_cidr = each.value["allow_sg_cidr"]
  subnet_ids     = module.vpc.subnets[each.value["subnet_ref"]]

  vpc_id        = module.vpc.vpc_id
  env           = var.env
  bastion_nodes = var.bastion_nodes
  asg           = false
  vault_token   = var.vault_token
  zone_id       = var.zone_id

}