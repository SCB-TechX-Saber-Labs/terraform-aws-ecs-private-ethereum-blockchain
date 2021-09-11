variable "region" {
  type        = string
  description = "The target AWS region"
}

variable "network_name" {
  type        = string
  description = "The network name to distinguish the deployment from others"
}

variable "number_of_nodes" {
  type        = number
  description = "Number of Ethereum client nodes"
  default     = 2
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

variable "subnet_ids" {
  type        = list
  description = "The AWS subnets"

}

variable "vpc_id" {
  type        = string
  description = "The target AWS VPC"
}