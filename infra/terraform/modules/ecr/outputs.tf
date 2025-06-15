output "ob_repository_url" {
  value = aws_ecr_repository.this.repository_url
}

output "k6_repository_url" {
  value = aws_ecr_repository.k6.repository_url
}