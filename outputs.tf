output "alb_dns_name" {
  value       = aws_lb.test.dns_name
  description = "The domain name of the load balancer"
}

output "rds_hostname" {
  value = module.mysql.rds_hostname
}