resource "aws_iam_role" "amp_amg_task_role" {
  name = "ecs-task-role-amp-amg"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "amp_amg_permissions" {
  name = "ecs-task-amp-amg-policy"
  role = aws_iam_role.amp_amg_task_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      # AMP: Remote Write, Query, Rules
      {
        Effect = "Allow",
        Action = [
          "aps:RemoteWrite",
          "aps:GetSeries",
          "aps:GetLabels",
          "aps:GetMetricMetadata",
          "aps:GetTimeSeriesData"
        ],
        Resource = "*"
      },
      # AMG: Describe workspaces, query APIs
      {
        Effect = "Allow",
        Action = [
          "grafana:DescribeWorkspace",
          "grafana:QueryMetrics",
          "grafana:DescribeWorkspaceAuthentication"
        ],
        Resource = "*"
      },
      # CloudWatch Logs にログを出す（任意）
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "*"
      },
      {
        Effect: "Allow",
        Action: [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:DeleteObject",
          "s3:GetObjectTagging",
          "s3:PutObjectTagging"
        ],
        Resource: [
          "*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "tempo_amp_write" {
  role       = aws_iam_role.amp_amg_task_role.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonPrometheusRemoteWriteAccess"
}

resource "aws_cloudwatch_log_group" "this" {
  name              = var.log_group_name
  retention_in_days = var.log_retention_days
}

resource "aws_ecs_cluster" "this" {
  name = "ob-cluster"
}

resource "aws_ecs_task_definition" "this" {
  family                   = "ob-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = aws_iam_role.amp_amg_task_role.arn

  container_definitions = jsonencode([
    {
      name      = "web"
      image     = var.container_image
      portMappings = [
        {
          containerPort = 4317
          hostPort = 4317
        },
        {
          containerPort = 3200
          hostPort = 3200
        },
        {
          containerPort = 3100
          hostPort = 3100
        },
        {
          containerPort = 13133
          hostPort = 13133
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.this.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = var.log_stream_prefix
        }
      }
    }
  ])
}

resource "aws_ecs_service" "this" {
  name            = "ob-service"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets         = var.subnets
    security_groups = [var.ob_ecs_sg_id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.ob_grpc_nlb_target_group_arn
    container_name   = "web"
    container_port   = 4317
  }

  load_balancer {
    target_group_arn = var.ob_tempo_nlb_target_group_arn
    container_name   = "web"
    container_port   = 3200
  }

  load_balancer {
    target_group_arn = var.ob_loki_nlb_target_group_arn
    container_name   = "web"
    container_port   = 3100
  }

}

