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

  provisioner "remote-exec" {
    connection {
      type = "ssh"
      user = "ubuntu"
      private_key = "${file("${path.module}/ssh/instance_keypair")}"
      script_path = "${path.cwd}/scripts/setup-docker.sh"
    }
  }
}