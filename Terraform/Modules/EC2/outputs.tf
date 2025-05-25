output "EC2_ID" {
  value = aws_instance.EC2.id
}

output "EC2_PUB_IP" {
  value = aws_instance.EC2.public_ip
}

output "EC2_PRIV_IP" {
  value = aws_instance.EC2.private_ip
}