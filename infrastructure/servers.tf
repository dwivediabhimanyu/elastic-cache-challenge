# Data : Get latest Ubuntu 20 Sever AMI from Canonical
data "aws_ami" "ubuntu-20" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}


# Resource : Create Private Key using RSA 
resource "tls_private_key" "key" {
  algorithm = "RSA"
}

# Resource : Create .pem file with key on local machnine
resource "local_file" "private_key" {
  filename          = "${var.namespace}-key.pem"
  sensitive_content = tls_private_key.key.private_key_pem
  file_permission   = "0400"
}

# Resource : AWS Key Pair
resource "aws_key_pair" "key_pair" {
  key_name   = "${var.namespace}-key"
  public_key = tls_private_key.key.public_key_openssh
}



# Resource : EC2 instance in a public subnet
resource "aws_instance" "ec2_public" {
  ami                         = data.aws_ami.ubuntu-20.id
  associate_public_ip_address = true
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.key_pair.key_name
  subnet_id                   = module.vpc.public_subnets[0]
  vpc_security_group_ids      = [aws_security_group.public_sg.id]

  tags = {
    "Name" = "${var.namespace}-EC2-PUBLIC"
  }

}
