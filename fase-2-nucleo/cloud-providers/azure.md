# Azure — Alternativa para Ambientes Microsoft

## Objetivo

Entender Azure como alternativa de cloud, especialmente comum em empresas com Microsoft, Active Directory, Windows Server e .NET.

## Serviços equivalentes

| Conceito | AWS | Azure |
| --- | --- | --- |
| máquina virtual | EC2 | Virtual Machines |
| storage de objetos | S3 | Blob Storage |
| rede privada | VPC | Virtual Network |
| banco gerenciado | RDS | Azure SQL / Database for PostgreSQL |
| IAM | IAM | Microsoft Entra ID / RBAC |
| load balancer HTTP | ALB | Application Gateway |

## Virtual Network

Virtual Network é a rede privada no Azure.

```text
Virtual Network
├── Subnet pública
├── Subnet privada
├── Network Security Group
└── Route Table
```

## Network Security Group

NSG controla tráfego de entrada e saída em subnets ou interfaces de rede.

Exemplo:

| Porta | Origem | Destino |
| --- | --- | --- |
| 80 | internet | app gateway |
| 443 | internet | app gateway |
| 5432 | subnet app | banco |

## Quando escolher Azure

- empresa já usa Microsoft 365 e Entra ID
- workloads Windows/.NET
- integração forte com ferramentas Microsoft
- políticas corporativas já centralizadas no Azure

## Mini-desafio

1. Compare EC2 com Azure Virtual Machines.
2. Compare S3 com Blob Storage.
3. Desenhe uma Virtual Network com app e banco.
4. Defina regras de NSG para web e banco.
