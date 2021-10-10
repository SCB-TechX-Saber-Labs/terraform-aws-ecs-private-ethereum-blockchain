locals {

  host_ip_file       = "${local.shared_volume_container_path}/host_ip"
  task_revision_file = "${local.shared_volume_container_path}/task_revision"
  service_file       = "${local.shared_volume_container_path}/service"
  hosts_folder       = "${local.shared_volume_container_path}/hosts"

  metadata_container_status_file = "${local.shared_volume_container_path}/metadata_container_status"


  bootstrap_commands = [
    "mkdir -p ${local.data_dir}/geth",
    "echo \"\" > ${local.password_file}",
    "bootnode -genkey ${local.data_dir}/geth/nodekey",
    "export NODE_ID=$(bootnode -nodekey ${local.data_dir}/geth/nodekey -writeaddress)",
    "geth version",
    "echo Creating an account for this node",
    "geth --datadir ${local.data_dir} account new --password ${local.password_file}",
    "export KEYSTORE_FILE=$(ls ${local.data_dir}/keystore/ | head -n1)",
    "export ACCOUNT_ADDRESS=$(cat ${local.data_dir}/keystore/$KEYSTORE_FILE | sed 's/^.*\"address\":\"\\([^\"]*\\)\".*$/\\1/g')",
    "echo Writing account address $ACCOUNT_ADDRESS to ${local.account_address_file}",
    "echo $ACCOUNT_ADDRESS > ${local.account_address_file}",
    "echo Writing Node Id [$NODE_ID] to ${local.node_id_file}",
    "echo $NODE_ID > ${local.node_id_file}",
  ]

  bootstrap_container_definition = {
    name      = local.bootstrap_container_name
    image     = var.go_ethereum_docker_image
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
      {
        sourceVolume  = local.shared_volume_name
        containerPath = local.shared_volume_container_path
      }
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
        "[ -f ${local.node_id_file} ];",
      ]
    }

    entrypoint = [
      "/bin/sh",
      "-c",
      join("\n", local.bootstrap_commands),
    ]

    dockerLabels = "${local.common_tags}"

    cpu = 0
  }
}