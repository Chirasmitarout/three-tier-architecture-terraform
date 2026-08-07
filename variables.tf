variable "aws_region" {}

variable "vpc_cidr" {}

variable "azs" {
  type = list(string)
}

variable "public_subnets" {
  type = list(string)
}

variable "private_app_subnets" {
  type = list(string)
}

variable "private_db_subnets" {
  type = list(string)
}

variable "db_instance_class" {}

variable "allocated_storage" {}

variable "db_name" {}

variable "db_username" {}

variable "db_password" {
  sensitive = true
}

variable "instance_type" {}

variable "key_name" {}

variable "public_key_path" {}