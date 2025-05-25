output "ALB_DNS" {
  value = aws_lb.ALB.dns_name
}

output "TG_Arn" {
  value = aws_lb_target_group.LB_TG.arn
}