variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "ami_id" {
  description = "AMI ID for EC2"
  type        = string
}

variable "instance_type" {
  type = string
}

variable "security_group_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "iam_instance_profile" {
  type = string
  default = null
}
