############################
# Outputs
############################

output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnets" {
  value = aws_subnet.public[*].id
}

output "private_app_subnets" {
  value = aws_subnet.private_app[*].id
}

output "private_db_subnets" {
  value = aws_subnet.private_db[*].id
}

############################################
# Outputs
############################################

output "rds_endpoint" {
  value = aws_db_instance.mysql.endpoint
}

output "rds_database_name" {
  value = aws_db_instance.mysql.db_name
}

############################################
# Outputs
############################################

output "public_ip" {
  value = aws_eip.public_ip.public_ip
}

output "private_ips" {
  value = aws_instance.private[*].private_ip
}

output "alb_dns_name" {
  value = aws_lb.alb.dns_name
}