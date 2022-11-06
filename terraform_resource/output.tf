output "webapp_ip" {
    description = "Aplication URL"
    value = aws_lb.prod_lb.dns_name
  
}