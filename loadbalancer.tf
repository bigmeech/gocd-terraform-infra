resource "aws_lb" "gocd_lb" {
  name = "gocd-build-server-lb"
  load_balancer_type = "application"
  security_groups = [
    "${aws_security_group.allow_http.id}"
  ]

  subnets = ["${data.aws_subnet_ids.default_vpc_subnets.ids}"]
}