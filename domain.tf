data "aws_route53_zone" "domain" {
  name = "azeemahmed.online"
}

resource "aws_route53_record" "frontend" {
  depends_on = [ aws_lb.app_lb ]
  zone_id = data.aws_route53_zone.domain.zone_id
  name    = "frontend"
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
  name    = "backend"
  type    = "A"
  alias {
    name                   = aws_lb.app_lb.dns_name
    zone_id                = aws_lb.app_lb.zone_id
    evaluate_target_health = true
  }
}