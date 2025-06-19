output "zone_name_servers" {
  description = "NS records to copy to your registrar"
  value       = aws_route53_zone.primary.name_servers
}

output "frontend_url" {
  value = "https://${var.frontend_subdomain}.${aws_route53_zone.primary.name}"
}

output "api_url" {
  value = "https://${var.api_subdomain}.${aws_route53_zone.primary.name}"
}
