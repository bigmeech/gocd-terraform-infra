provider "aws" {
  region = "${var.region}"
  profile = "${var.profile}"
}

resource "aws_key_pair" "gocd_instance_keypair" {
  key_name = "instance_keypair"
  public_key = "${file("${path.module}/ssh/instance_keypair.pub")}"
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