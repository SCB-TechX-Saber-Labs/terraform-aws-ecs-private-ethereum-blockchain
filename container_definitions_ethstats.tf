locals {

  ethstats_port                    = 3000
  ethstats_container_name          = "ethstats"

  ethstats_common_container_definitions = [
    local.ethstats_container_definition
  ]

  ethstats_container_definitions = [
    jsonencode(local.ethstats_common_container_definitions),
  ]

  ethstats_container_definition = {
    name      = local.ethstats_container_name
    image     = var.ethstats_docker_image
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
        "netstat -an | grep 3000 > /dev/null; if [ 0 != $? ]; then exit 1; fi;",
      ]
    }

    environments = []

    portMappings = [
      {
        "hostPort" : local.ethstats_port,
        "protocol" : "tcp",
        "containerPort" : local.ethstats_port
      },
    ]

    volumesFrom = []

    environment = [
      {
        "name" : "WS_SECRET",
        "value" : random_id.ethstat_secret.hex
      }
    ]

    entrypoint = []

    dockerLabels = local.common_tags

    cpu = 0
  }
}



resource "random_id" "ethstat_secret" {
  byte_length = 16
}
