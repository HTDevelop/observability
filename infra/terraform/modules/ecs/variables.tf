variable "vpc_id" {}
variable "subnets" { type = list(string) }
variable "ob_ecs_sg_id" {}
variable "container_image" {}
variable "execution_role_arn" {
  type        = string
}
variable "ob_grpc_nlb_target_group_arn" {}
variable "ob_tempo_nlb_target_group_arn" {}
variable "ob_loki_nlb_target_group_arn" {}
variable "log_group_name" {
  type        = string
  description = "CloudWatch log group name"
}

variable "log_retention_days" {
  type        = number
  default     = 7
}

variable "log_stream_prefix" {
  type        = string
  default     = "ecs"
}

variable "aws_region" {}