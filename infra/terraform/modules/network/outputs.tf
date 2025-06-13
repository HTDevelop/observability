output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "ob_ecs_sg_id" {
  value = aws_security_group.ob_ecs_sg.id
}
output "ob_nlb_sg_id" {
  value = aws_security_group.ob_nlb_sg.id
}

output "ob_nlb_tempo_sg_id" {
  value = aws_security_group.ob_nlb_tempo_sg.id
}

output "ob_nlb_loki_sg_id" {
  value = aws_security_group.ob_nlb_loki_sg.id
}