resource "aws_lb" "gocd_lb" {
  name = "gocd-build-server-lb"
  load_balancer_type = "application"
  security_groups = [
    "${aws_security_group.allow_http.id}"
  ]

  subnets = ["${data.aws_subnet_ids.default_vpc_subnets.ids}"]
}

resource "aws_acm_certificate" "cert" {
  domain_name = "gocd.build.teleimpact.io"
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "cert_validation_record" {
  name = "${aws_acm_certificate.cert.domain_validation_options.0.resource_record_name}"
  type = "${aws_acm_certificate.cert.domain_validation_options.0.resource_record_type}"
  zone_id = "${data.aws_route53_zone.route_53_zone.id}"
  records = ["${aws_acm_certificate.cert.domain_validation_options.0.resource_record_value}"]
  ttl = 60
}

resource "aws_acm_certificate_validation" "cert_validation" {
  certificate_arn = "${aws_acm_certificate.cert.arn}"
  validation_record_fqdns = ["${aws_route53_record.cert_validation_record.fqdn}"]
}

resource "aws_lb_target_group" "gocd_lb_target_group" {
  name = "gocd-instance-target"
  port = 8153
  protocol = "HTTP"
  vpc_id = "${data.aws_vpc.default_vpc.id}"
}

resource "aws_lb_listener_certificate" "lb_listener_cert" {
  certificate_arn = "${aws_acm_certificate.cert.arn}"
  listener_arn = "${aws_lb_listener.gocd_lb_listener.arn}"
}

resource "aws_lb_listener" "gocd_lb_listener" {
  load_balancer_arn = "${aws_lb.gocd_lb.arn}"
  port = 443
  protocol = "HTTPS"
  ssl_policy = "ELBSecurityPolicy-2016-08"
  certificate_arn = "${aws_acm_certificate.cert.arn}"
  "default_action" {
    type = "forward"
    target_group_arn = "${aws_lb_target_group.gocd_lb_target_group.arn}"
  }
}