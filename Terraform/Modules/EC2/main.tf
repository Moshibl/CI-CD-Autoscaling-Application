resource "aws_instance" "EC2" {
  ami                         = var.AMI
  instance_type               = var.Instance_Type
  subnet_id                   = var.Subnet_Id
  vpc_security_group_ids      = [var.SG]
  associate_public_ip_address = var.Is_Public
  key_name                    = var.Key_Name
  user_data                   = var.UserData
  tags = {
    Name = var.Instance_Name
  }
}
