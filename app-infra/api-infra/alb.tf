data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }

  tags = {
    tier = "private"
  }
}

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }

  tags = {
    tier = "public"
  }
}

resource "aws_lb" "application_load_balancer" {
  name               = "${var.app}-${var.environment}-alb"
  internal           = var.internal
  load_balancer_type = "application"
  subnets            = data.aws_subnets.private.ids
  security_groups    = [aws_security_group.alb_sg.id]
}

resource "aws_lb_target_group" "api_target_group" {
  name        = "${var.app}-${var.environment}-api"
  port        = var.api_target_group_port
  protocol    = var.api_target_group_protocol
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    interval            = var.api_health_check_interval
    path                = var.api_health_check_path
    healthy_threshold   = var.api_health_check_healthy_threshold
    unhealthy_threshold = var.api_health_check_unhealthy_threshold
    timeout             = var.api_health_check_timeout
  }
}

resource "aws_lb_listener" "api_listener" {
  load_balancer_arn = aws_lb.application_load_balancer.arn
  port              = var.api_listener_port
  protocol          = var.api_listener_protocol
  ssl_policy        = var.api_https_listener_ssl_policy
  certificate_arn   = var.api_https_listener_certificate_arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api_target_group.arn
  }
}

resource "aws_lb_target_group" "processing_target_group" {
  name        = "${var.app}-${var.environment}-processing"
  port        = var.processing_target_group_port
  protocol    = var.processing_target_group_protocol
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    interval            = var.processing_health_check_interval
    path                = var.processing_health_check_path
    healthy_threshold   = var.processing_health_check_healthy_threshold
    unhealthy_threshold = var.processing_health_check_unhealthy_threshold
    timeout             = var.processing_health_check_timeout
  }
}

resource "aws_lb_listener" "processing_listener" {
  load_balancer_arn = aws_lb.application_load_balancer.arn
  port              = var.processing_listener_port
  protocol          = var.processing_listener_protocol
  ssl_policy        = var.processing_https_listener_ssl_policy
  certificate_arn   = var.processing_https_listener_certificate_arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.processing_target_group.arn
  }
}

module "dns" {
  source         = "../../common/modules/route53"
  domain_name    = "sample-app"
  dns_name       = aws_lb.application_load_balancer.dns_name
  ttl            = 300
  hosted_zone_id = var.hosted_zone_id
  lb_zone_id     = aws_lb.application_load_balancer.zone_id
}