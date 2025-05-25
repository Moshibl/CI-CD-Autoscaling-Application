variable "AMI" {
  type = string
}

variable "Instance_Type" {
  type    = string
  default = "t2.micro"
}

variable "Subnet_Id" {
  type = string
}

variable "SG" {
  type = string
}

variable "Is_Public" {
  type = bool
}

variable "Key_Name" {
  type = string
}

variable "UserData" {
  type    = string
  default = ""
}

variable "Instance_Name" {
  type = string
}