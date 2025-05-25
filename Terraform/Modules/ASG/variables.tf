variable "LaunchTMP_Name" {
  type = string
}

variable "AMI" {
  type = string
}

variable "Instance_Type" {
  type = string
}

variable "Key_Name" {
  type = string
}

variable "Security_Group_Ids" {
  type = list(string)
}

variable "UserData" {
  type    = string
  default = ""
}

variable "ASG_Name" {
  type = string
}

variable "ASG_Instance_Name" {
  type = string
}

variable "ASG_Instance_Role" {
  type = string
}

variable "Desired_Capacity" {
  type = number
}

variable "Min_Size" {
  type = number
}

variable "Max_Size" {
  type = number
}

variable "VPC_Zone_Id" {
  type = list(string)
}

variable "TG_Arns" {
  type = list(string)
}