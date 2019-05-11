provider "aws" {
  region = "${var.region}"
  profile = "${var.profile}"
}


resource "aws_instance" "gocd_instance" {
  ami = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"

  tags {
    Name = "GoCDServer"
  }

  provisioner "remote-exec" {
    connection {
      type = "ssh"
      user = "${var.region}"
      host_key = "${var.public_key}"
      private_key = "${var.private_key}"
      script_path = "${path.cwd}/scripts/setup-docker.sh"
    }
  }
}