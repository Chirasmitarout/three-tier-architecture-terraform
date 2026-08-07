aws_region = "us-west-2"

vpc_cidr = "10.0.0.0/16"

azs = [
  "us-west-2a",
  "us-west-2b"
]

public_subnets = [
  "10.0.1.0/24",
  "10.0.2.0/24"
]

private_app_subnets = [
  "10.0.11.0/24",
  "10.0.12.0/24"
]

private_db_subnets = [
  "10.0.21.0/24",
  "10.0.22.0/24"
]

db_instance_class = "db.t3.micro"

allocated_storage = 20

db_name = "three_tier_db"

db_username = "admin"

db_password = "Cloud123"

instance_type = "t2.micro"

key_name = "three-tier-key"

public_key_path = "~/.ssh/three-tier-key.pub"