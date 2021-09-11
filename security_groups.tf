resource "aws_security_group" "go_ethereum" {
  name        = "go-ethereum-sg-${var.network_name}"
  description = "Security group used in Ethereum network ${var.network_name}"
  vpc_id      = var.vpc_id

  ingress {
      from_port = local.go_ethereum_p2p_port
      protocol  = "tcp"
      to_port   = local.go_ethereum_rpc_port

      cidr_blocks = [
        "0.0.0.0/0",
      ]

      description = "Allow all"
  }
  

  egress {
    from_port = 0
    protocol  = "-1"
    to_port   = 0

    cidr_blocks = [
      "0.0.0.0/0",
    ]

    description = "Allow geth rpc"
  }

  tags = "${merge(local.common_tags, tomap({"Name" = format("ethereum-sg-%s", var.network_name)}))}"
}

resource "aws_security_group" "ethstats" {
  name        = "go-ethereum-sg-ethstats-${var.network_name}"
  description = "Security group used in Ethereum network ${var.network_name}"
  vpc_id      = var.vpc_id

  ingress {
      from_port = local.ethstats_port
      protocol  = "tcp"
      to_port   = local.ethstats_port

      cidr_blocks = [
        "0.0.0.0/0",
      ]

      description = "Allow Ethereum ethstats"
  }
  

  egress {
    from_port = 0
    protocol  = "-1"
    to_port   = 0

    cidr_blocks = [
      "0.0.0.0/0",
    ]

    description = "Allow all"
  }

  tags = "${merge(local.common_tags, tomap({"Name" = format("ethereum-sg-%s", var.network_name)}))}"
}

resource "aws_security_group" "ethereum_lite_exlorer" {
  name        = "go-ethereum-sg-explorer-${var.network_name}"
  description = "Security group used in Ethereum network ${var.network_name}"
  vpc_id      = var.vpc_id

  ingress {
      from_port = local.explorer_port
      protocol  = "tcp"
      to_port   = local.explorer_port

      cidr_blocks = [
        "0.0.0.0/0",
      ]

      description = "Allow Ethereum Lite Explorer"
  }
  

  egress {
    from_port = 0
    protocol  = "-1"
    to_port   = 0

    cidr_blocks = [
      "0.0.0.0/0",
    ]

    description = "Allow all"
  }

  tags = "${merge(local.common_tags, tomap({"Name" = format("ethereum-sg-%s", var.network_name)}))}"
}

