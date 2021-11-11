output "load-balancer-dns" {
  value = aws_alb.application_load_balancer.dns_name
}