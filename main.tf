provider "aws" {
  region = "${var.region}"
  profile = "${var.profile}"
}

resource "aws_key_pair" "gocd_instance_keypair" {
  key_name = "instance_keypair"
  public_key = "${file("${path.module}/ssh/instance_keypair.pub")}"
}

resource "aws_eip" "gocd_eip" {
  instance = "${aws_instance.gocd_instance.id}"
}

resource "aws_route53_record" "build_server_record" {
  zone_id = "${data.aws_route53_zone.route_53_zone.id}"
  name    = "gocd.build.teleimpact.io"
  type    = "A"
  ttl     = "300"
  records = ["${aws_eip.gocd_eip.public_ip}"]
}

resource "aws_instance" "gocd_instance" {
  ami = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"

  key_name = "${aws_key_pair.gocd_instance_keypair.key_name}"

  tags {
    Name = "GoCDServer"
  }

  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = "${file("${path.module}/ssh/instance_keypair")}"
  }

  provisioner "file" {
    destination = "/tmp/setup-docker.sh"
    source = "./scripts/setup-docker.sh"
  }

  provisioner "file" {
    destination = "/tmp/setup-gocd.sh"
    source = "./scripts/setup-gocd.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/setup-docker.sh",
      "/tmp/setup-docker.sh"
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/setup-gocd.sh",
      "/tmp/setup-gocd.sh"
    ]
  }
}