output "ssh_connection" {
  value = "ssh -i ${aws_key_pair.gocd_instance_keypair.key_name}.pem ubuntu@${aws_instance.gocd_instance.public_dns}"
}

output "go_server_url" {
  value = "https://${aws_route53_record.build_server_record.fqdn}"
}