# Manage the zone itself
resource "aws_route53_zone" "primary" {
  name    = var.root_domain
  comment = "Primary zone managed entirely by Terraform"
}

# API CNAME -> ALB
resource "aws_route53_record" "api" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "${var.api_subdomain}.${aws_route53_zone.primary.name}"
  type    = "CNAME"
  ttl     = 300
  records = [aws_lb.app_alb.dns_name]
}

# Frontend A-alias -> S3 website
resource "aws_route53_record" "frontend" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "${var.frontend_subdomain}.${aws_route53_zone.primary.name}"
  type    = "A"

  alias {
    name                   = aws_s3_bucket.frontend.website_domain
    zone_id                = aws_s3_bucket.frontend.hosted_zone_id
    evaluate_target_health = false
  }
}
