resource "aws_launch_template" "this" {
  name_prefix   = "${var.project_name}-${var.environment}-lt-"
  image_id      = var.ami_id
  instance_type = var.instance_type

  vpc_security_group_ids = [var.security_group_id]

  user_data = base64encode(<<-EOF
    #!/bin/bash
    set -e

    # Update system
    yum update -y

    # Install SSM Agent
    yum install -y amazon-ssm-agent

    # Enable & start SSM Agent
    systemctl enable amazon-ssm-agent
    systemctl start amazon-ssm-agent

    # Install Python (required for Ansible)
    yum install -y python3
  EOF
  )

  iam_instance_profile {
    name = aws_iam_instance_profile.ssm_profile.name
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name        = "${var.project_name}-${var.environment}-ec2"
      Environment = var.environment
      Project     = var.project_name
      Role        = "web"
    }
  }
}
