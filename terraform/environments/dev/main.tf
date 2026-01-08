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


# 🔹 Add AMI Data Source (Best Practice)
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}


# 🔹 Call Launch Template Module
module "launch_template" {
  source = "../../modules/launch-template"

  project_name      = var.project_name
  environment       = var.environment
  ami_id            = data.aws_ami.amazon_linux.id
  instance_type     = "t2.micro"
  security_group_id = module.security_groups.ec2_sg_id
  subnet_ids        = module.vpc.private_subnet_ids
}
