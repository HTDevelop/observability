resource "aws_ecr_repository" "this" {
  name = var.ob_repo_name
}

resource "aws_ecr_repository" "k6" {
  name = var.k6_repo_name
}