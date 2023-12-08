resource "aws_lb" "network_load_balancer" {
  name               = "${var.app}-${var.environment}-nlb"
  internal           = var.internal
  load_balancer_type = "network"
  subnets            = data.aws_subnets.private.ids
}

resource "aws_lb_target_group" "nlb_target_group" {
  name        = "${var.app}-alb-target-group"
  port        = var.api_listener_port
  protocol    = "TCP"
  vpc_id      = var.vpc_id
  target_type = "alb"
  health_check {
    port                = var.api_listener_port
    protocol            = var.api_listener_protocol
    unhealthy_threshold = 3
    healthy_threshold   = 3
    matcher             = "200-499"
    path                = var.processing_health_check_path
  }
}

resource "aws_lb_listener" "nlb_listener" {
  load_balancer_arn = aws_lb.network_load_balancer.arn
  port              = var.api_listener_port
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nlb_target_group.arn
  }
}

resource "aws_lb_target_group_attachment" "nlb-alb" {

  target_group_arn = aws_lb_target_group.nlb_target_group.arn
  target_id        = aws_lb.application_load_balancer.arn
  port             = var.api_listener_port
}

resource "aws_api_gateway_vpc_link" "vpc_link" {
  name        = "${var.app}-vpc-link"
  target_arns = [aws_lb.network_load_balancer.arn]
}