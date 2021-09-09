resource "aws_cloudwatch_log_group" "go_ethereum" {
  name              = "/ecs/go-ethereum/${var.network_name}"
  retention_in_days = "7"
  tags              = local.common_tags
}
