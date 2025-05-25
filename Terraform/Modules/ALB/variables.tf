variable "LB_Name" {
  type = string
}

variable "Is_Internal" {
  type = bool
}

variable "Security_Group_Id" {
  type = list(string)
}

variable "Subnet_Ids" {
  type = list(string)
}

variable "TargetGroupName" {
  type = string
}

variable "VPC_ID" {
  type = string
}