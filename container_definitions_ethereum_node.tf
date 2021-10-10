locals {

  shared_volume_name           = "ethereum_shared_volume"
  shared_volume_container_path = "/shared-volume"
  data_dir                     = "${local.shared_volume_container_path}/data"

  static_nodes_file       = "${local.data_dir}/static-nodes.json"
  permissioned_nodes_file = "${local.data_dir}/permissioned-nodes.json"


  genesis_file         = "${local.shared_volume_container_path}/genesis.json"
  password_file        = "${local.shared_volume_container_path}/passwords.txt"
  node_id_file         = "${local.shared_volume_container_path}/node_id"
  account_address_file = "${local.shared_volume_container_path}/first_account_address"
  node_ids_folder      = "${local.shared_volume_container_path}/nodeids"
  accounts_folder      = "${local.shared_volume_container_path}/accounts"

  bootstrap_container_name   = "bootstrap"
  metadata_container_name    = "metadata"
  go_ethereum_container_name = "go-ethereum"


  go_ethereum_rpc_port = 22000
  go_ethereum_p2p_port = 21000

  genesis = {

    "alloc" = {}

    "coinbase" = "0x0000000000000000000000000000000000000000"

    "config" = {
      "homesteadBlock"      = 0
      "byzantiumBlock"      = 0
      "constantinopleBlock" = 0
      "petersburgBlock" : 0,
      "chainId"     = "${random_integer.network_id.result}"
      "eip150Block" = 0
      "eip155Block" = 0
      "eip158Block" = 0,
      "clique" : {
        "period" : 5,
        "epoch" : 30000
      }
    }

    "difficulty" = "0x01"
    "extraData"  = "0x0000000000000000000000000000000000000000000000000000000000000000"
    "gasLimit"   = "0xE0000000"
    "mixHash"    = "0x0000000000000000000000000000000000000000000000000000000000000000"
    "nonce"      = "0x0"
    "parentHash" = "0x0000000000000000000000000000000000000000000000000000000000000000"
    "timestamp"  = "0x00"
  }

  go_ethereum_config_commands = [
    "mkdir -p ${local.data_dir}/geth",
    "echo \"\" > ${local.password_file}",
    "echo \"Creating ${local.static_nodes_file} and ${local.permissioned_nodes_file}\"",
    "all=\"\"; for f in `ls ${local.node_ids_folder}`; do nodeid=$(cat ${local.node_ids_folder}/$f); ip=$(cat ${local.hosts_folder}/$f); all=\"$all,\\\"enode://$nodeid@$ip:${var.go_ethereum_p2p_port}?discport=0\\\"\"; done; all=$${all:1}",
    "echo \"[$all]\" > ${local.static_nodes_file}",
    "echo \"[$all]\" > ${local.permissioned_nodes_file}",
    "echo Permissioned Nodes: $(cat ${local.permissioned_nodes_file})",
    "geth --datadir ${local.data_dir} init ${local.genesis_file}",
    "export IDENTITY=$(cat ${local.service_file} | awk -F: '{print $2}')",
    ""
  ]

  go_ethereum_args = join(" ", [
    "--datadir ${local.data_dir}",
    "--rpc",
    "--rpcaddr 0.0.0.0",
    "--rpcapi admin,eth,debug,miner,net,shh,txpool,personal,web3,clique",
    "--rpcport ${var.go_ethereum_rpc_port}",
    "--rpcvhosts=*",
    "--rpccorsdomain=*",
    "--port ${var.go_ethereum_p2p_port}",
    "--unlock 0",
    "--password ${local.password_file}",
    "--nodiscover",
    "--networkid ${random_integer.network_id.result}",
    "--verbosity 5",
    "--nousb",
    "--identity $IDENTITY",
    "--allow-insecure-unlock",
    "--syncmode full",
    "--mine",
    "--miner.threads 1",
    "--ethstats \"$IDENTITY:${random_id.ethstat_secret.hex}@${aws_lb.nlb_ethereum.dns_name}:${var.ethstats_port}\"",
  ])

  go_ethereum_run_commands = concat(
    [
      "set -e",
      "echo Wait until metadata bootstrap completed ...",
      "while [ ! -f \"${local.metadata_container_status_file}\" ]; do sleep 1; done"
    ],
    local.go_ethereum_config_commands,
    [
      "echo 'Running geth with: ${local.go_ethereum_args}'",
      "geth ${local.go_ethereum_args}"
    ]
  )

  go_ethereum_container_definition = {
    name      = local.go_ethereum_container_name
    image     = var.go_ethereum_docker_image
    essential = "true"

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
      },
    ]

    healthCheck = {
      interval    = 30
      retries     = 10
      timeout     = 60
      startPeriod = 300

      command = [
        "CMD-SHELL",
        "[ -S ${local.data_dir}/geth.ipc ];",
      ]
    }

    environments = []

    portMappings = [
      {
        "hostPort" : var.go_ethereum_rpc_port,
        "protocol" : "tcp",
        "containerPort" : var.go_ethereum_rpc_port
      }
    ]

    volumesFrom = []

    environment = []

    entrypoint = [
      "/bin/sh",
      "-c",
      join("\n", local.go_ethereum_run_commands)
    ]

    dockerLabels = "${local.common_tags}"

    cpu = 0
  }

  node_container_definitions = [
    local.bootstrap_container_definition,
    local.metadata_container_definition,
    local.go_ethereum_container_definition
  ]

  container_definitions = [
    jsonencode(local.node_container_definitions)
  ]
}

resource "random_integer" "network_id" {
  min = 2018
  max = 9999

  keepers = {
    changes_when = var.network_name
  }
}