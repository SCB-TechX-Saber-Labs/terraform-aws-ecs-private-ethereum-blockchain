resource "aws_iam_role" "ecs_task" {
  name = "ethereum-ecs-task-${var.network_name}"
  path = "/ecs/"
  tags = local.common_tags

  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": [
          "ecs.amazonaws.com",
          "ecs-tasks.amazonaws.com"
        ]
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution" {
  role       = aws_iam_role.ecs_task.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "ecs_task_cloudwatch" {
  role       = aws_iam_role.ecs_task.id
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

data "aws_iam_policy_document" "ecs_task" {
  statement {
    sid = "AllowS3Access"

    actions = [
      "s3:*",
    ]

    resources = [
      "arn:aws:s3:::${local.ethereum_bucket}",
      "arn:aws:s3:::${local.ethereum_bucket}/*",
    ]
  }

  statement {
    sid = "AllowECS"

    actions = [
      "ecs:DescribeTasks"
    ]

    resources = [
      "*"
    ]
  }
}

resource "aws_iam_policy" "ecs_task" {
  name        = "ethereum-ecs-task-policy-${var.network_name}"
  path        = "/"
  description = "This policy allows task to access S3 bucket"
  policy      = "${data.aws_iam_policy_document.ecs_task.json}"
}

resource "aws_iam_role_policy_attachment" "ecs_task_s3" {
 role       = "${aws_iam_role.ecs_task.id}"
 policy_arn = "${aws_iam_policy.ecs_task.arn}"
}

