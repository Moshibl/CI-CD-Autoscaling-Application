# --------------------------------------------------
# Global Vars
# --------------------------------------------------
region   = "us-east-1"
Key_Name = "Key"
WorkDir  = "/home/mohamed/MultiTier-Autoscaling-Application"
# --------------------------------------------------
# EC2 Vars
# --------------------------------------------------
Master_Name  = "Master"
Slave_Name   = "Slave"
Jenkins_Type = "t2.medium"
# --------------------------------------------------
# VPC Vars
# --------------------------------------------------
VPC_Name      = "MyVPC"
VPC_CIDR      = "10.0.0.0/16"
PubSub1_CIDR  = "10.0.1.0/24"
PubSub2_CIDR  = "10.0.2.0/24"
PrivSub1_CIDR = "10.0.3.0/24"
PrivSub2_CIDR = "10.0.4.0/24"
PrivSub3_CIDR = "10.0.5.0/24"
PrivSub4_CIDR = "10.0.6.0/24"
AZ1           = "us-east-1a"
AZ2           = "us-east-1b"
# --------------------------------------------------
# ASG Vars
# --------------------------------------------------
AMI                   = "ami-084568db4383264d4"
NGINX_AMI             = "ami-057d5bdca75d5a296"
Instance_Type         = "t2.micro"
Proxy_TMP             = "PublicLaunchTMP"
Priv_TMP              = "PrivateLaunchTMP"
ProxyASG_Instance     = "Proxy-EC2"
PrivASG_Instance      = "Backend-EC2"
Proxy_Instance_Role   = "Proxy"
Backend_Instance_Role = "Backend"
ProxyASG              = "PublicASG"
PrivASG               = "PrivateASG"
# --------------------------------------------------
# ALB Vars
# --------------------------------------------------
EXT_Name = "External-ALB"
INT_Name = "Internal-ALB"
ProxyTG  = "PublicTG"
PrivTG   = "PrivateTG"
# --------------------------------------------------
# END
# --------------------------------------------------