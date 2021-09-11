resource "aws_lb" "nlb_ethereum" {
  name               = "nlb-${local.ecs_cluster_name}"
  internal           = !var.is_public_subnets
  load_balancer_type = "network"
  subnets            = var.subnet_ids

  enable_cross_zone_load_balancing = true

}

resource "aws_lb_target_group" "nlb_tg_go_ethereum" {
  name     = local.ecs_cluster_name
  port     = var.go_ethereum_rpc_port
  target_type = "ip"
  protocol = "TCP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_listener" "nlb_listener_go_ethereum" {
  load_balancer_arn = aws_lb.nlb_ethereum.arn
  port              = var.go_ethereum_rpc_port
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nlb_tg_go_ethereum.arn
  }
}

resource "aws_lb_target_group" "nlb_tg_ethstats" {
  name     = "ethstats-${local.ecs_cluster_name}"
  port     = var.ethstats_port
  target_type = "ip"
  protocol = "TCP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_listener" "nlb_listener_ethstats" {
  load_balancer_arn = aws_lb.nlb_ethereum.arn
  port              = var.ethstats_port
  protocol          = "TCP"
  
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nlb_tg_ethstats.arn
  }
}

resource "aws_lb_target_group" "nlb_tg_ethereum_explorer" {
  name     = "explorer-${local.ecs_cluster_name}"
  port     = var.ethereum_explorer_port
  target_type = "ip"
  protocol = "TCP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_listener" "nlb_listener_ethereum_explorer" {
  load_balancer_arn = aws_lb.nlb_ethereum.arn
  port              = var.ethereum_explorer_port
  protocol          = "TCP"
  
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nlb_tg_ethereum_explorer.arn
  }
}