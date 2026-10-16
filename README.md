# Infraestrutura básica na AWS com Terraform

Projeto de infraestrutura como código (IaC) que provisiona uma rede na AWS e um servidor web, de forma reproduzível e com boas práticas de segurança.

## O que este projeto cria

- **VPC** com DNS habilitado
- **Sub-rede pública** com **Internet Gateway** e tabela de rotas
- **Security Group**: HTTP (80) aberto ao público; **SSH (22) restrito ao meu IP**
- **Instância EC2** (Amazon Linux 2023, `t3.micro`) com **nginx** instalado via `user_data`
- **Par de chaves SSH** a partir da chave pública

```
Internet
   |
[Internet Gateway]
   |
[VPC 10.0.0.0/16]
   |
[Sub-rede pública 10.0.1.0/24]
   |
[EC2 + nginx]  <-- Security Group: 80 (público) | 22 (somente meu IP)
```

## Decisões de segurança

- SSH liberado **apenas** para o IP informado em `my_ip_cidr`, nunca `0.0.0.0/0`
- **IMDSv2 obrigatório** na instância
- Disco raiz **criptografado** (gp3)
- Nenhuma credencial ou chave privada no repositório; `terraform.tfvars` e `*.pem` estão no `.gitignore`
- Sem NAT Gateway, para evitar custo desnecessário em ambiente de estudo

## Pré-requisitos

- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.5
- [AWS CLI](https://aws.amazon.com/cli/) configurado (`aws configure`) com um usuário IAM de permissões limitadas
- Uma chave SSH (`ssh-keygen -t ed25519`)

## Como usar

```bash
# 1. Variáveis
cp terraform.tfvars.example terraform.tfvars
# edite o arquivo com o seu IP (curl ifconfig.me) e sua chave pública

# 2. Inicializar, revisar e aplicar
terraform init
terraform validate
terraform plan
terraform apply

# 3. Testar
# abra a URL exibida em "website_url" no navegador
# ou conecte por SSH com o comando de "ssh_command"

# 4. Destruir tudo ao terminar (evita custo)
terraform destroy
```

## Variáveis

| Variável | Descrição | Padrão |
|---|---|---|
| `aws_region` | Região da AWS | `us-east-1` |
| `project_name` | Prefixo dos recursos e tags | `infra-basica-aws` |
| `vpc_cidr` | CIDR da VPC | `10.0.0.0/16` |
| `public_subnet_cidr` | CIDR da sub-rede pública | `10.0.1.0/24` |
| `instance_type` | Tipo da instância | `t3.micro` |
| `my_ip_cidr` | Meu IP em CIDR (SSH) | obrigatória |
| `ssh_public_key` | Chave pública SSH | obrigatória |

## Custos

Em contas novas, a `t3.micro` costuma estar coberta pelo free tier ou por créditos iniciais, mas confira as regras vigentes da sua conta. Rode `terraform destroy` ao terminar os testes.

## Resultado

Após o `terraform apply`, o nginx responde publicamente na porta 80:

<img width="864" height="157" alt="image" src="https://github.com/user-attachments/assets/159b201e-5334-4488-aebd-951733922561" />


Testado com Terraform e AWS provider 5.x na região us-east-1. Recursos removidos
com `terraform destroy` ao final do teste.

- [ ] Separar a rede e a instância em módulos
- [ ] Guardar o state remoto em S3 com lock em DynamoDB
- [ ] Pipeline com GitHub Actions (`fmt`, `validate`, `plan`)
- [ ] Sub-rede privada e acesso via SSM Session Manager (sem SSH)
