
resource "aws_instance" "ec2" {
  ami             = data.aws_ami.amazon_linux.id
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.allow_tcp.name]
  user_data       = file("docker-jenkins-setup.sh")
  key_name        = data.aws_key_pair.jenkins_keyPair.key_name
  tags = {
    Name = "Project-Omar"
  }
}

resource "aws_security_group" "allow_tcp" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"


  ingress {
    description = "TLS from VPC"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["84.71.108.229/32"]
  }
  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "SSH from VPC"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

