resource "aws_lb" "ob_grpc_nlb" {
  name               = "ob-grpc-nlb"
  internal           = false
  load_balancer_type = "network"
  subnets            = var.subnets
  security_groups    = [var.ob_nlb_sg_id]
  enable_cross_zone_load_balancing = true
}

resource "aws_lb_target_group" "ob_grpc_tg" {
  name        = "ob-grpc-target"
  port        = 4317
  protocol    = "TCP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    protocol = "TCP"
    port     = "4317"
  }
}

resource "aws_lb_listener" "grpc_listener" {
  load_balancer_arn = aws_lb.ob_grpc_nlb.arn
  port              = 4317
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ob_grpc_tg.arn
  }
}


resource "aws_lb" "ob_tempo_nlb" {
  name               = "ob-tempo-nlb"
  internal           = false
  load_balancer_type = "network"
  subnets            = var.subnets
  security_groups    = [var.ob_nlb_tempo_sg_id]
  enable_cross_zone_load_balancing = true
}

resource "aws_lb_target_group" "ob_tempo_tg" {
  name        = "ob-tempo-target"
  port        = 3200
  protocol    = "TCP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    protocol = "TCP"
    port     = "3200"
  }
}

resource "aws_lb_listener" "tempo_listener" {
  load_balancer_arn = aws_lb.ob_tempo_nlb.arn
  port              = 3200
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ob_tempo_tg.arn
  }
}


resource "aws_lb" "ob_loki_nlb" {
  name               = "ob-loki-nlb"
  internal           = false
  load_balancer_type = "network"
  subnets            = var.subnets
  security_groups    = [var.ob_nlb_loki_sg_id]
  enable_cross_zone_load_balancing = true
}

resource "aws_lb_target_group" "ob_loki_tg" {
  name        = "ob-loki-target"
  port        = 3100
  protocol    = "TCP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    protocol = "TCP"
    port     = "3100"
  }
}

resource "aws_lb_listener" "loki_listener" {
  load_balancer_arn = aws_lb.ob_loki_nlb.arn
  port              = 3100
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ob_loki_tg.arn
  }
}