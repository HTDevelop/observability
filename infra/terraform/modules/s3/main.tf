resource "aws_s3_bucket" "tempo_s3" {
  bucket = var.tempo_s3_name
}

resource "aws_s3_bucket" "loki_s3" {
  bucket = var.loki_s3_name
}
