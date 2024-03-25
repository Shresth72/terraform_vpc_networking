resource "aws_alb" "application_load_balancer" {
  name               = "${var.project_name}-application-load-balancer"
  load_balancer_type = "application"
  subnets = [
    "${var.public_subnet_az1_id}",
    "${var.public_subnet_az2_id}"
  ]
  security_groups = ["${var.alb_security_group_id}"]
}

resource "aws_lb_target_group" "alb_target_group" {
  name        = "${var.project_name}-alb-target-group"
  port        = var.container_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_alb.application_load_balancer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group.arn
  }
}
