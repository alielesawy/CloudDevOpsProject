resource "tls_private_key" "my_key_pair" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "my_key_pair" {
  key_name   = "my-key-pair"
  public_key = tls_private_key.my_key_pair.public_key_openssh
}

resource "local_file" "private_key" {
  content  = tls_private_key.my_key_pair.private_key_pem
  filename = "${path.module}/my-key-pair.pem"
}

# Output Key Pair Name
output "key_pair_name" {
  value = aws_key_pair.my_key_pair.key_name
}

# Output Private Key (Sensitive)
output "private_key" {
  value     = tls_private_key.my_key_pair.private_key_pem
  sensitive = true
}