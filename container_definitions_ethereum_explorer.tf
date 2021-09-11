locals {
  ethereum_explorer_container_name          = "ethereum-explorer"

  ethereum_explorer_common_container_definitions = [
    local.ethereum_explorer_container_definition
  ]

  ethereum_explorer_container_definitions = [
    jsonencode(local.ethereum_explorer_common_container_definitions),
  ]

  ethereum_explorer_container_definition = {
    name      = local.ethereum_explorer_container_name
    image     = var.ethereum_lite_explorer_docker_image
    essential = "true"

    logConfiguration = {
      logDriver = "awslogs"

      options = {
        awslogs-group         = aws_cloudwatch_log_group.go_ethereum.name
        awslogs-region        = var.region
        awslogs-stream-prefix = "logs"
      }
    }

    mountPoints = []

    healthCheck = {
      interval    = 30
      retries     = 10
      timeout     = 60
      startPeriod = 300

      command = [
        "CMD-SHELL",
        "netstat -an | grep 80 > /dev/null; if [ 0 != $? ]; then exit 1; fi;",
      ]
    }

    environments = []

    portMappings = [
      {
        "hostPort" : var.ethereum_explorer_port,
        "protocol" : "tcp",
        "containerPort" : var.ethereum_explorer_port
      },
    ]

    volumesFrom = []

    environment = [
      {
        "name" : "APP_NODE_URL",
        "value" : "http://${aws_lb.nlb_ethereum.dns_name}:${var.go_ethereum_rpc_port}"
      }
    ]

    entrypoint = []

    dockerLabels = local.common_tags

    cpu = 0
  }
}