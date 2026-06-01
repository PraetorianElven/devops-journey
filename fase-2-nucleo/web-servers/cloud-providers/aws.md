# AWS — IAM, EC2, S3, VPC e RDS

## Objetivo

Estudar fundamentos de AWS com foco prático em infraestrutura para aplicações.

Arquitetura comum:

```text
Internet
↓
Security Group / Load Balancer
↓
EC2 ou Kubernetes
↓
Aplicação
↓
RDS / Redis / S3
```

## IAM

IAM controla identidade e permissão.

| Recurso | Função |
| --- | --- |
| User | identidade humana ou programática |
| Group | conjunto de usuários |
| Role | identidade assumida por serviço |
| Policy | documento JSON com permissões |

Exemplo de policy somente leitura em S3:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["s3:GetObject", "s3:ListBucket"],
      "Resource": "*"
    }
  ]
}
```

Boa prática: EC2 deve usar Role, não chave fixa dentro do servidor.

## EC2

EC2 é máquina virtual na AWS.

Acesso SSH:

```bash
ssh -i chave.pem ubuntu@IP_PUBLICO
```

Logs systemd:

```bash
journalctl -u nginx -n 100
```

## Security Group

Security Group é firewall associado a recursos AWS.

Exemplo para servidor web:

| Porta | Origem | Motivo |
| --- | --- | --- |
| 22 | seu IP | SSH |
| 80 | `0.0.0.0/0` | HTTP |
| 443 | `0.0.0.0/0` | HTTPS |

Exemplo para banco:

| Porta | Origem | Motivo |
| --- | --- | --- |
| 5432 | security group da aplicação | Postgres |

## S3

S3 armazena objetos, como arquivos, backups e artefatos.

Casos de uso:

- upload de imagens
- logs
- backups
- state remoto do Terraform
- site estático

Conceitos:

| Conceito | Significado |
| --- | --- |
| bucket | contêiner de objetos |
| object key | caminho/nome do arquivo |
| versioning | versões de objetos |
| lifecycle | regras de expiração/transição |

## VPC

VPC é a rede privada dentro da AWS.

Estrutura:

```text
VPC
├── Public Subnet
│   └── recursos com rota para Internet Gateway
├── Private Subnet
│   └── recursos sem exposição direta
├── Route Table
├── Internet Gateway
└── NAT Gateway
```

Uso comum:

| Recurso | Subnet recomendada |
| --- | --- |
| Load Balancer público | public subnet |
| EC2 de aplicação | private subnet |
| RDS | private subnet |

## RDS

RDS é banco gerenciado.

Exemplos:

- PostgreSQL
- MySQL
- MariaDB
- SQL Server

Boas práticas:

- deixar em subnet privada
- liberar acesso só do security group da aplicação
- habilitar backup
- definir janela de manutenção
- monitorar CPU, memória, conexões e storage

## Arquitetura moderna

```text
Cloudflare
↓
AWS ALB
↓
EC2 ou EKS
↓
Aplicação
↓
RDS + S3 + Redis
```

## Mini-desafio

1. Desenhe uma VPC com 2 public subnets e 2 private subnets.
2. Coloque ALB nas public subnets.
3. Coloque aplicação nas private subnets.
4. Coloque RDS em private subnets.
5. Defina security groups para cada camada.
