resource "aws_grafana_workspace" "this" {
  name                     = var.name
  authentication_providers = ["AWS_SSO"] # or ["SAML"]
  permission_type          = "SERVICE_MANAGED"
  role_arn                 = aws_iam_role.grafana_role.arn
  account_access_type      = "CURRENT_ACCOUNT"

  data_sources = ["PROMETHEUS", "CLOUDWATCH"]
}


resource "aws_iam_role" "grafana_role" {
  name = "grafana-assume-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "grafana.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })

  # 適宜、AMP へのアクセス権限を付与
}

resource "aws_iam_role_policy_attachment" "grafana_amp_access" {
  role       = aws_iam_role.grafana_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonPrometheusQueryAccess"
}

resource "aws_iam_role_policy" "amp_query_policy" {
  name = "AMPQueryPolicy"
  role = aws_iam_role.grafana_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "aps:ListWorkspaces",
          "aps:DescribeWorkspace",
          "aps:QueryMetrics",
          "aps:GetLabels",
          "aps:GetSeries",
          "aps:GetMetricMetadata"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy" "cloudwatch_policy" {
  name = "CloudWatchPolicy"
  role = aws_iam_role.grafana_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect: "Allow",
        Action: [
          "cloudwatch:ListMetrics",
          "cloudwatch:GetMetricData",
          "cloudwatch:GetMetricStatistics",
          "cloudwatch:DescribeAlarms",
          "cloudwatch:DescribeAlarmHistory",
          "logs:*"
        ],
        Resource: "*"
      }
    ]
  })
}