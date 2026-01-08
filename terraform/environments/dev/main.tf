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
  instance_type     = "t3.micro"
  security_group_id = module.security_groups.ec2_sg_id
  subnet_ids        = module.vpc.private_subnet_ids
}


module "alb_asg" {
  source = "../../modules/alb-asg"

  project_name              = var.project_name
  environment               = var.environment
  vpc_id                    = module.vpc.vpc_id
  public_subnet_ids         = module.vpc.public_subnet_ids
  private_subnet_ids        = module.vpc.private_subnet_ids
  alb_security_group_id     = module.security_groups.alb_sg_id
  launch_template_id        = module.launch_template.launch_template_id
  launch_template_version   = module.launch_template.launch_template_latest_version
}

module "monitoring" {
  source = "../../modules/monitoring"

  project_name = var.project_name
  environment  = var.environment
  asg_name     = module.alb_asg.asg_name
  alert_email  = var.alert_email
}
