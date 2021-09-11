output "_status" {
  value = <<EOT
Completed!

Network Name                          = ${var.network_name}
Number of Ethereum Nodes              = ${var.number_of_nodes}
Geth Task Revision                    = ${aws_ecs_task_definition.go_ethereum.revision}
Ethstats Task Revision                = ${aws_ecs_task_definition.ethstats.revision}
Ethereum Lite Explorer Task Revision  = ${aws_ecs_task_definition.ethereum_explorer.revision}
S3 Bucket Name                        = ${aws_s3_bucket.ethereum.bucket}
CloudWatch Log Group                  = ${aws_cloudwatch_log_group.go_ethereum.name}
EOT
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.ethereum.name
}

output "chain_id" {
  value = random_integer.network_id.result
}

output "nlb_dns" {
  value = aws_lb.nlb_ethereum.dns_name
}

output "ethereum_explorer_endpoint" {
  value = "http://${aws_lb.nlb_ethereum.dns_name}:${var.ethereum_explorer_port}"
}

output "ethstats_endpoint" {
  value = "http://${aws_lb.nlb_ethereum.dns_name}:${var.ethstats_port}"
}

output "geth_rpc_endpoint" {
  value = "http://${aws_lb.nlb_ethereum.dns_name}:${var.go_ethereum_rpc_port}"
}