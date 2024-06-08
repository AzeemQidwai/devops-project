data "aws_route53_zone" "domain" {
  name = var.domain_name
}

resource "aws_route53_record" "frontend" {
  depends_on = [ aws_lb.app_lb ]
  zone_id = data.aws_route53_zone.domain.zone_id
  name    = var.frontend_dns
  type    = "A"
  alias {
    name                   = aws_lb.app_lb.dns_name
    zone_id                = aws_lb.app_lb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "backend" {
  depends_on = [ aws_lb.app_lb ]
  zone_id = data.aws_route53_zone.domain.zone_id
  name    = var.backend_dns
  type    = "A"
  alias {
    name                   = aws_lb.app_lb.dns_name
    zone_id                = aws_lb.app_lb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "metabase" {
  depends_on = [ aws_lb.app_lb ]
  zone_id = data.aws_route53_zone.domain.zone_id
  name    = var.metabase_dns
  type    = "A"
  alias {
    name                   = aws_lb.app_lb.dns_name
    zone_id                = aws_lb.app_lb.zone_id
    evaluate_target_health = true
  }
}