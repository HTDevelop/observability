variable "vpc_id" {}
variable "subnets" { type = list(string) }
variable "ob_nlb_sg_id" {}
variable "ob_nlb_tempo_sg_id" {}
variable "ob_nlb_loki_sg_id" {}