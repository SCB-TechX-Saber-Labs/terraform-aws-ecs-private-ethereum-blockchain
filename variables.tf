variable "region" {
  type        = string
  description = "The target AWS region"
}

variable "vpc_id" {
  type        = string
  description = "The target AWS VPC"
}

variable "subnet_ids" {
  type        = list(any)
  description = "The AWS subnets for ECS tasks deployments and Load Balancer provisioning"

}

variable "is_public_subnets" {
  type        = bool
  description = "Indicate that if subnets supplied in subnet_ids are public subnets"
}

variable "network_name" {
  type        = string
  description = "The network name to distinguish this deployment from others"
}

variable "number_of_nodes" {
  type        = number
  description = "Number of Ethereum nodes"
  default     = 2
}

variable "initial_eth_allocations" {
  type        = map(any)
  description = "The map of wallet addresses and amounts in ETH to allocate the initial funds"
  default     = {}
}

variable "go_ethereum_p2p_port" {
  type        = number
  description = "The port number to expose the ethereum rpc endpoint"
  default     = 21000
}

variable "go_ethereum_rpc_port" {
  type        = number
  description = "The port number for ethereum p2p communication"
  default     = 22000
}

variable "ethstats_port" {
  type        = number
  description = "The port number to expose the ethstats endpoint"
  default     = 3000
}

variable "ethereum_explorer_port" {
  type        = number
  description = "The port number to expose the ethereum explorer endpoint"
  default     = 80
}


variable "go_ethereum_docker_image" {
  type        = string
  description = "The Go Ethereum docker image to run Ethereum client node"
  default     = "ethereum/client-go:alltools-v1.10.8"
}

variable "aws_cli_docker_image" {
  type        = string
  description = "The AWS CLI image to work with AWS services"
  default     = "amazon/aws-cli"
}

variable "ethstats_docker_image" {
  type        = string
  description = "The Ethereum ethstats monitoring tool docker image"
  default     = "puppeth/ethstats:latest"
}

variable "ethereum_lite_explorer_docker_image" {
  type        = string
  description = "The Ethereum Lite Explorer docker image"
  default     = "alethio/ethereum-lite-explorer:v1.0.0-beta.10"
} 