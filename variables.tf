variable "aws_region" {
  description = "Região da AWS onde os recursos serão criados."
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Prefixo usado no nome e nas tags dos recursos."
  type        = string
  default     = "infra-basica-aws"
}

variable "vpc_cidr" {
  description = "Bloco CIDR da VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "Bloco CIDR da sub-rede pública."
  type        = string
  default     = "10.0.1.0/24"
}

variable "instance_type" {
  description = "Tipo da instância EC2 (t3.micro é elegível ao free tier em contas novas)."
  type        = string
  default     = "t3.micro"
}

variable "my_ip_cidr" {
  description = "Seu IP público em formato CIDR (ex.: 203.0.113.10/32). Único IP autorizado a usar SSH."
  type        = string

  validation {
    condition     = can(cidrhost(var.my_ip_cidr, 0))
    error_message = "Informe um CIDR válido, por exemplo 203.0.113.10/32."
  }
}

variable "ssh_public_key" {
  description = "Conteúdo da sua chave PÚBLICA SSH (arquivo .pub)."
  type        = string
}
