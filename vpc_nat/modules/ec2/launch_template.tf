data "aws_ami" "ami_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm"]
  }
}

resource "aws_launch_template" "ecs_launch_template" {
  name          = "${var.ecs_cluster_name}-ec2-launch-template"
  description   = "ECS Launch Template"
  ebs_optimized = true
  image_id      = data.aws_ami.ami_linux_2.id
  instance_type = var.instance_type
  key_name      = var.aws_key_name
  vpc_security_group_ids = [var.ecs_security_group_id]

  user_data = base64decode(<<-EOF
    #!/bin/bash
    echo ECS_CLUSTER=${var.ecs_cluster_name} >> /etc/ecs/ecs.config
    EOF
  )

  iam_instance_profile {
    name = var.aws_iam_instance_profile_name
  }

  monitoring {
    enabled = true
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.ecs_cluster_name}-ecs-node"
    }
  }
}
