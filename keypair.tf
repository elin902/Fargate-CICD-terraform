resource "aws_key_pair" "default" {
  key_name   = "${var.name}-key"
  public_key = file("${var.ssh_pubkey_file}")
}