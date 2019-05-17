resource "aws_lb" "gocd_lb" {
  name = "gocd-build-server-lb"
  load_balancer_type = "application"
  security_groups = [
    "${aws_security_group.allow_http.id}",
    "${aws_security_group.allow_https.id}"
  ]

  subnets = ["${data.aws_subnet_ids.default_vpc_subnets.ids}"]
}

resource "aws_lb_target_group" "gocd_lb_target_group" {
  name = "gocd-instance-target"
  port = 8153
  protocol = "HTTP"
  vpc_id = "${data.aws_vpc.default_vpc.id}"
  target_type = "instance"
}

resource "aws_alb_target_group_attachment" "target" {
  target_group_arn = "${aws_lb_target_group.gocd_lb_target_group.arn}"
  target_id = "${aws_instance.gocd_instance.id}"
}

resource "aws_lb_listener_certificate" "lb_listener_cert" {
  certificate_arn = "${data.aws_acm_certificate.teleimpact_certificate.arn}"
  listener_arn = "${aws_lb_listener.gocd_lb_listener.arn}"
}

resource "aws_lb_listener" "gocd_lb_listener" {
  load_balancer_arn = "${aws_lb.gocd_lb.arn}"
  port = 443
  protocol = "HTTPS"
  ssl_policy = "ELBSecurityPolicy-2016-08"
  certificate_arn = "${data.aws_acm_certificate.teleimpact_certificate.arn}"
  "default_action" {
    type = "forward"
    target_group_arn = "${aws_lb_target_group.gocd_lb_target_group.arn}"
  }
}