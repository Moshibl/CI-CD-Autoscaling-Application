resource "tls_private_key" "KeyPair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "PublicKey" {
  key_name   = var.Key_Name
  public_key = tls_private_key.KeyPair.public_key_openssh
}

resource "local_file" "PrivateKey" {
  content         = tls_private_key.KeyPair.private_key_pem
  filename        = pathexpand("~/.ssh/${var.Key_Name}")
  file_permission = "0400"
}