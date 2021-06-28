# Output : EC2 ssh command
output "public_connection_string" {
  description = "Copy/Paste/Enter - To Connect to Public EC2"
  value       = "ssh -i ${aws_key_pair.key_pair.key_name}.pem ubuntu@${aws_instance.ec2_public.public_ip}"
}
