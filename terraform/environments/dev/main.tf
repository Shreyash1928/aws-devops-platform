module "vpc" {
  source = "../../modules/vpc"

  project_name       = var.project_name
  environment        = var.environment
  vpc_cidr           = var.vpc_cidr

  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets

  availability_zones = ["ap-south-1a", "ap-south-1b"]
}

module "security_groups" {
  source = "../../modules/security-groups"

  project_name = var.project_name
  environment  = var.environment
  vpc_id       = module.vpc.vpc_id
}
