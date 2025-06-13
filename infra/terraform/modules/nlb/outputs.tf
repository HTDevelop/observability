output "ob_grpc_nlb_target_group_arn" {
  value = aws_lb_target_group.ob_grpc_tg.arn
}

output "ob_tempo_nlb_target_group_arn" {
  value = aws_lb_target_group.ob_tempo_tg.arn
}

output "ob_loki_nlb_target_group_arn" {
  value = aws_lb_target_group.ob_loki_tg.arn
}