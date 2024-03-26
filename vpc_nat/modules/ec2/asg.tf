// ASG creates EC2 instances in the ECS Cluster using the Launch Template

resource "aws_autoscaling_group" "ecs_asg" {
  name_prefix = "${var.ecs_cluster_name}-asg"
  vpc_zone_identifier = [
    var.public_subnet_az1_id,
    var.public_subnet_az2_id
  ]
  min_size = 2
  max_size = 3

  health_check_grace_period = 0
  health_check_type         = "EC2"
  protect_from_scale_in     = false

  launch_template {
    id      = aws_launch_template.ecs_launch_template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.ecs_cluster_name}-ecs-node"
    propagate_at_launch = true
  }

  tag {
    key                 = "AmazonECSManaged"
    value               = "true"
    propagate_at_launch = true
  }
}
