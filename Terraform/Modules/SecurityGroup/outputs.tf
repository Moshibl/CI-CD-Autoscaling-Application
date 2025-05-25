output "External_ALB_SG" {
  value = aws_security_group.External_ALB_SG.id
}

output "Proxy_SG" {
  value = aws_security_group.Proxy_SG.id
}

output "Internal_ALB_SG" {
  value = aws_security_group.Internal_ALB_SG.id
}

output "Backend_SG" {
  value = aws_security_group.Backend_SG.id
}

output "Master_SG" {
  value = aws_security_group.Master_SG.id
}

output "Slave_SG" {
  value = aws_security_group.Slave_SG.id
}