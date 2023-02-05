resource "aws_route53_zone" "r53_hosted_zone" {
  name = var.domain_name
}

resource "aws_route53_record" "site_domain" {
  zone_id = aws_route53_zone.r53_hosted_zone.zone_id
  name    = var.sub_domain_name
  type    = "A"

  alias {
    name                   = aws_lb.alb.dns_name
    zone_id                = aws_lb.alb.zone_id
    evaluate_target_health = true
  }
}

# Create a new Namecheap domain DNS
resource "namecheap_domain_dns" "my_dns" {
  domain_name = var.domain_name

  nameservers = [
    aws_route53_zone.r53_hosted_zone.name_servers[0],
    aws_route53_zone.r53_hosted_zone.name_servers[1],
    aws_route53_zone.r53_hosted_zone.name_servers[2],
    aws_route53_zone.r53_hosted_zone.name_servers[3]
  ]
}