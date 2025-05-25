output "MASTER_IP" {
  value = module.Master.EC2_PUB_IP
}

output "SLAVE_IP" {
  value = module.Slave.EC2_PRIV_IP
}

output "EXT_DNS" {
  value = module.External_ALB.ALB_DNS
}