output "ssh_connection" {
  value = "ssh -i ${aws_key_pair.gocd_instance_keypair.key_name}.pem ubuntu@${aws_instance.gocd_instance.public_dns}"
}