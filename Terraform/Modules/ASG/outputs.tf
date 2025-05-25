output "ASG_Instance_IP" {
  value = join(" ", data.aws_instances.ASG_Instances.private_ips)
}
