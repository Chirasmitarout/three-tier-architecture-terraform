############################################
# Security Group for RDS
############################################

resource "aws_security_group" "rds_sg" {
  name        = "rds-security-group"
  description = "Allow MySQL from App Tier"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "MySQL"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"

    # Replace with your App Security Group later
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "RDS-SG"
  }
}

############################################
# DB Subnet Group
############################################

resource "aws_db_subnet_group" "db_subnet_group" {
  name = "three-tier-db-subnet-group"

  subnet_ids = [
    aws_subnet.private_db[0].id,
    aws_subnet.private_db[1].id
  ]

  tags = {
    Name = "DB Subnet Group"
  }
}

############################################
# RDS MySQL Instance
############################################

resource "aws_db_instance" "mysql" {

  identifier = "three-tier-mysql"

  engine         = "mysql"
  engine_version = "8.0"

  instance_class = var.db_instance_class

  allocated_storage     = var.allocated_storage
  max_allocated_storage = 100

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  publicly_accessible = false

  multi_az = true

  skip_final_snapshot = true

  storage_encrypted = true

  backup_retention_period = 7

  tags = {
    Name = "Three-Tier-RDS"
  }
}

