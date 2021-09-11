# terraform-aws-ecs-private-ethereum-blockchain

A terraform module to setup a private Ethereum network, using [Go Ethereum](https://geth.ethereum.org/), including [Ethereum Network Stats](https://github.com/cubedro/eth-netstats) and [Ethereum Lite Explorer](https://github.com/Alethio/ethereum-lite-explorer) on Amazon ECS.

## Usage

```hcl
module "private_ethereum" {
    source                  = "SCB-TechX-Saber-Labs/ecs-private-ethereum-blockchain/aws"
    version                 = "0.1.0"

    region                  = "ap-southeast-1"

    network_name            = "devel"

    subnet_ids              = [
        "subnet-0d3dd066f35696746",
        "subnet-0233a4b40b131621b",
        "subnet-05580a63c0e79abd2"
    ]

    is_public_subnets       = false

    vpc_id                  = "vpc-0204ec5c6f7ad746e"

    initial_eth_allocations = {
        "0x89205A3A3b2A69De6Dbf7f01ED13B2108B2c43e7": "100"
    }

}

output "status" {
    value = module.private_ethereum._status
}

output "chain_id" {
     value = module.private_ethereum.chain_id
}

output "ecs_cluster_name" {
     value = module.private_ethereum.ecs_cluster_name
}

output "ethereum_explorer_endpoint" {
     value = module.private_ethereum.ethereum_explorer_endpoint
}

output "ethstats_endpoint" {
     value = module.private_ethereum.ethstats_endpoint
}

output "geth_rpc_endpoint" {
     value = module.private_ethereum.geth_rpc_endpoint
}

output "nlb_dns" {
     value = module.private_ethereum.nlb_dns
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.57 |
| <a name="requirement_local"></a> [local](#requirement\_local) | ~> 2.1 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.57.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.1.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.go_ethereum](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_ecs_cluster.ethereum](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster) | resource |
| [aws_ecs_service.ethereum_explorer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_ecs_service.ethstats](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_ecs_service.go_ethereum](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_ecs_task_definition.ethereum_explorer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_ecs_task_definition.ethstats](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_ecs_task_definition.go_ethereum](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_iam_policy.ecs_task](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.ecs_task](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.ecs_task_cloudwatch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ecs_task_execution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ecs_task_s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lb.nlb_ethereum](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.nlb_listener_ethereum_explorer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener.nlb_listener_ethstats](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener.nlb_listener_go_ethereum](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.nlb_tg_ethereum_explorer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_lb_target_group.nlb_tg_ethstats](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_lb_target_group.nlb_tg_go_ethereum](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_s3_bucket.ethereum](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_security_group.ethereum_exlorer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.ethstats](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.go_ethereum](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [random_id.bucket_postfix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [random_id.ethstat_secret](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [random_integer.network_id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/integer) | resource |
| [aws_caller_identity.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ecs_task](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_cli_docker_image"></a> [aws\_cli\_docker\_image](#input\_aws\_cli\_docker\_image) | The AWS CLI image to work with AWS services | `string` | `"amazon/aws-cli"` | no |
| <a name="input_ethereum_explorer_port"></a> [ethereum\_explorer\_port](#input\_ethereum\_explorer\_port) | The port number to expose the ethereum explorer endpoint | `number` | `80` | no |
| <a name="input_ethereum_lite_explorer_docker_image"></a> [ethereum\_lite\_explorer\_docker\_image](#input\_ethereum\_lite\_explorer\_docker\_image) | The Ethereum Lite Explorer docker image | `string` | `"alethio/ethereum-lite-explorer:v1.0.0-beta.10"` | no |
| <a name="input_ethstats_docker_image"></a> [ethstats\_docker\_image](#input\_ethstats\_docker\_image) | The Ethereum ethstats monitoring tool docker image | `string` | `"puppeth/ethstats:latest"` | no |
| <a name="input_ethstats_port"></a> [ethstats\_port](#input\_ethstats\_port) | The port number to expose the ethstats endpoint | `number` | `3000` | no |
| <a name="input_go_ethereum_docker_image"></a> [go\_ethereum\_docker\_image](#input\_go\_ethereum\_docker\_image) | The Go Ethereum docker image to run Ethereum client node | `string` | `"ethereum/client-go:alltools-v1.10.8"` | no |
| <a name="input_go_ethereum_p2p_port"></a> [go\_ethereum\_p2p\_port](#input\_go\_ethereum\_p2p\_port) | The port number to expose the ethereum rpc endpoint | `number` | `21000` | no |
| <a name="input_go_ethereum_rpc_port"></a> [go\_ethereum\_rpc\_port](#input\_go\_ethereum\_rpc\_port) | The port number for ethereum p2p communication | `number` | `22000` | no |
| <a name="input_initial_eth_allocations"></a> [initial\_eth\_allocations](#input\_initial\_eth\_allocations) | The map of wallet addresses and amounts in ETH to allocate the initial funds | `map` | `{}` | no |
| <a name="input_is_public_subnets"></a> [is\_public\_subnets](#input\_is\_public\_subnets) | Indicate that if subnets supplied in subnet\_ids are public subnets | `bool` | n/a | yes |
| <a name="input_network_name"></a> [network\_name](#input\_network\_name) | The network name to distinguish this deployment from others | `string` | n/a | yes |
| <a name="input_number_of_nodes"></a> [number\_of\_nodes](#input\_number\_of\_nodes) | Number of Ethereum nodes | `number` | `2` | no |
| <a name="input_region"></a> [region](#input\_region) | The target AWS region | `string` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | The AWS subnets for ECS tasks deployments and Load Balancer provisioning | `list` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The target AWS VPC | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output__status"></a> [\_status](#output\_\_status) | n/a |
| <a name="output_chain_id"></a> [chain\_id](#output\_chain\_id) | n/a |
| <a name="output_ecs_cluster_name"></a> [ecs\_cluster\_name](#output\_ecs\_cluster\_name) | n/a |
| <a name="output_ethereum_explorer_endpoint"></a> [ethereum\_explorer\_endpoint](#output\_ethereum\_explorer\_endpoint) | n/a |
| <a name="output_ethstats_endpoint"></a> [ethstats\_endpoint](#output\_ethstats\_endpoint) | n/a |
| <a name="output_geth_rpc_endpoint"></a> [geth\_rpc\_endpoint](#output\_geth\_rpc\_endpoint) | n/a |
| <a name="output_nlb_dns"></a> [nlb\_dns](#output\_nlb\_dns) | n/a |

## Credits

This terraform module is modified from the [ConsenSys's Quorum Cloud repository](https://github.com/ConsenSys/quorum-cloud).