output "vpc_id" {
  description = "ID da VPC criada."
  value       = aws_vpc.main.id
}

output "instance_public_ip" {
  description = "IP público da instância."
  value       = aws_instance.web.public_ip
}

output "website_url" {
  description = "URL para testar o nginx no navegador."
  value       = "http://${aws_instance.web.public_ip}"
}

output "ssh_command" {
  description = "Comando SSH (ajuste o caminho da sua chave privada)."
  value       = "ssh -i ~/.ssh/id_ed25519 ec2-user@${aws_instance.web.public_ip}"
}
