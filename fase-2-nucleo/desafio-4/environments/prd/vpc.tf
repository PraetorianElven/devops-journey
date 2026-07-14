data "aws_availability_zones" "available" {}

locals {
  azs = slice(data.aws_availability_zones.available.names, 0, var.availability_zone_count)
}

module "vpc" {
  source = "../../modules-terraform/vpc"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs                     = local.azs
  public_subnets          = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 8, k)]
  private_subnets         = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 8, k + 10)]
  map_public_ip_on_launch = var.map_public_ip_on_launch

  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support
  enable_nat_gateway   = var.enable_nat_gateway
  single_nat_gateway   = var.single_nat_gateway # lab: 1 NAT so - em prd use false para HA

  tags = var.vpc_tags
}
