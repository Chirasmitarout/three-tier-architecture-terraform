############################################
# Get Latest Amazon Linux 2023 AMI
############################################

data "aws_ami" "amazon_linux" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

############################################
# Key Pair
############################################

resource "aws_key_pair" "three_tier_key" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

############################################
# Public Security Group
############################################

resource "aws_security_group" "public_sg" {
  name   = "public-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]   # Restrict to your IP in production
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Public-SG"
  }
}

############################################
# Private Security Group
############################################

resource "aws_security_group" "private_sg" {
  name   = "private-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    description     = "SSH from Bastion"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.public_sg.id]
  }

  ingress {
    description = "Application Port"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"

    security_groups = [
      aws_security_group.public_sg.id
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Private-SG"
  }
}

############################################
# Public EC2 Instance
############################################

resource "aws_instance" "public" {

  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public[0].id
  key_name               = aws_key_pair.three_tier_key.key_name
  vpc_security_group_ids = [aws_security_group.public_sg.id]

  associate_public_ip_address = true

  tags = {
    Name = "Public-EC2"
  }
}

############################################
# Elastic IP
############################################

resource "aws_eip" "public_ip" {

  instance = aws_instance.public.id
  domain   = "vpc"

  depends_on = [
    aws_internet_gateway.igw
  ]
}

############################################
# Private EC2 Instances
############################################

resource "aws_instance" "private" {

  count = 2

  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private_app[count.index].id
  key_name               = aws_key_pair.three_tier_key.key_name
  vpc_security_group_ids = [aws_security_group.private_sg.id]

  associate_public_ip_address = false

  tags = {
    Name = "Private-App-${count.index + 1}"
  }
}

