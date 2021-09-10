output "_status" {
  value = <<EOT
Completed!

Network Name                = ${var.network_name}
Geth Docker Image           = ${var.go_ethereum_docker_image}
Number of Ethereum Nodes    = ${var.number_of_nodes}
Geth Task Revision          = ${aws_ecs_task_definition.go_ethereum.revision}
Ethstats Task Revision      = ${aws_ecs_task_definition.ethstats.revision}
CloudWatch Log Group        = ${aws_cloudwatch_log_group.go_ethereum.name}
EOT
}

output "nlb_dns" {
  value = aws_lb.nlb_ethereum.dns_name
}

output "ethstats_endpoint" {
  value = "http://${aws_lb.nlb_ethereum.dns_name}:${local.ethstats_port}"
}

output "geth_rpc_endpoint" {
  value = "http://${aws_lb.nlb_ethereum.dns_name}:${local.go_ethereum_rpc_port}"
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.ethereum.name
}

output "chain_id" {
  value = random_integer.network_id.result
}

output "s3_bucket_name" {
  value = aws_s3_bucket.ethereum.bucket
}