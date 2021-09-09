locals {

  ethstats_port                    = 3000
  ethstats_container_name          = "ethstats"
  ethstats_metadata_container_name = "metadata"
  ethstats_metadata_status_file    = "metadata_container_status"
  ethstats_host_folder             = "${local.shared_volume_container_path}/ethstats_folder"
  ethstats_host_ip_file            = "eth_statshost"

  ethstats_metadata_commands = [
    "set -e",
    "yum install jq -y",
    "export HOST_IP=$(curl -s 169.254.170.2/v2/metadata | jq '.Containers[] | select(.Name == \"${local.ethstats_metadata_container_name}\") | .Networks[] | select(.NetworkMode == \"awsvpc\") | .IPv4Addresses[0]' -r )",
    "echo \"Host IP: $HOST_IP\"",
    "echo $HOST_IP > ${local.ethstats_host_ip_file}",
    "aws s3 cp ${local.ethstats_host_ip_file} s3://${local.ethereum_bucket}/ethstats_host/${local.normalized_host_ip}",

    // Write status
    "echo \"Done!\" > ${local.ethstats_metadata_status_file}",

  ]

  ethstats_metadata_container_definition = {

    name      = local.ethstats_metadata_container_name
    image     = var.aws_cli_docker_image
    essential = "false"

    logConfiguration = {
      logDriver = "awslogs"

      options = {
        awslogs-group         = aws_cloudwatch_log_group.go_ethereum.name
        awslogs-region        = var.region
        awslogs-stream-prefix = "logs"
      }
    }

    mountPoints = [
    ]

    environments = []

    portMappings = []

    volumesFrom = []

    healthCheck = {
      interval    = 30
      retries     = 10
      timeout     = 60
      startPeriod = 300

      command = [
        "CMD-SHELL",
        "[ -f ${local.ethstats_metadata_status_file} ];",
      ]
    }

    entryPoint = [
      "/bin/sh",
      "-c",
      join("\n", local.ethstats_metadata_commands),
    ]

    dockerLabels = local.common_tags

    cpu = 0
  }

  ethstats_common_container_definitions = [
    local.ethstats_metadata_container_definition,
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
