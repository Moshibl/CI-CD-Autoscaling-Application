output "Key_Name" {
  value = aws_key_pair.PublicKey.key_name
}
output "Key_Path" {
  value = local_file.PrivateKey.filename
}