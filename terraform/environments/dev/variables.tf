variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
}
variable "vpc_cidr" {

}

variable "public_subnets" {

}

variable "private_subnets" {

}
