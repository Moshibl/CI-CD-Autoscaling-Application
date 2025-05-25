# --------------------------------------------------
# Global Vars
# --------------------------------------------------
variable "region" {
  type = string
}

variable "Key_Name" {
  type = string
}

variable "WorkDir" {
  type = string
}
# --------------------------------------------------
# Global Vars
# --------------------------------------------------

variable "Master_Name" {
  type = string
}

variable "Slave_Name" {
  type = string
}

variable "Jenkins_Type" {
  type = string
}

# --------------------------------------------------
# VPC Vars
# --------------------------------------------------

variable "VPC_Name" {
  type = string
}

variable "VPC_CIDR" {
  type = string
}

variable "PubSub1_CIDR" {
  type = string
}

variable "PubSub2_CIDR" {
  type = string
}

variable "PrivSub1_CIDR" {
  type = string
}

variable "PrivSub2_CIDR" {
  type = string
}

variable "PrivSub3_CIDR" {
  type = string
}

variable "PrivSub4_CIDR" {
  type = string
}
variable "AZ1" {
  type = string
}

variable "AZ2" {
  type = string
}

# --------------------------------------------------
# ASG Vars
# --------------------------------------------------

variable "AMI" {
  type = string
}

variable "NGINX_AMI" {
  type = string
}

variable "Instance_Type" {
  type = string
}

variable "ProxyASG" {
  type = string
}

variable "PrivASG" {
  type = string
}

variable "Proxy_TMP" {
  type = string
}

variable "Priv_TMP" {
  type = string
}

variable "ProxyASG_Instance" {
  type = string
}

variable "PrivASG_Instance" {
  type = string
}

variable "Proxy_Instance_Role" {
  type = string
}

variable "Backend_Instance_Role" {
  type = string
}

# --------------------------------------------------
# ALB Vars
# --------------------------------------------------

variable "EXT_Name" {
  type = string
}
variable "INT_Name" {
  type = string
}
variable "ProxyTG" {
  type = string
}
variable "PrivTG" {
  type = string
}