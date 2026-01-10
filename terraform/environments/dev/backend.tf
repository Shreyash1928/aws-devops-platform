terraform {
  backend "s3" {
    bucket         = "shreyash-terraform-state"
    key            = "aws-devops-platform/dev/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
