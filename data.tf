data "aws_ami" "amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-2.0.20220316.0-x86_64-gp2"]
  }
}

data "aws_key_pair" "jenkins_keyPair" {
  filter {
    name   = "tag:Name"
    values = ["Jenkins"]
  }
}
