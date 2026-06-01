# GCP — Alternativa com Foco em Kubernetes e Dados

## Objetivo

Entender GCP como alternativa de cloud, bastante usada em Kubernetes, dados e workloads gerenciados.

## Serviços equivalentes

| Conceito | AWS | GCP |
| --- | --- | --- |
| máquina virtual | EC2 | Compute Engine |
| storage de objetos | S3 | Cloud Storage |
| rede privada | VPC | VPC Network |
| banco gerenciado | RDS | Cloud SQL |
| Kubernetes | EKS | GKE |
| IAM | IAM | IAM |
| load balancer | ALB/NLB | Cloud Load Balancing |

## VPC no GCP

No GCP, VPC é global, e subnets são regionais.

```text
VPC global
├── subnet us-central1
├── subnet southamerica-east1
└── firewall rules
```

## GKE

GKE é Kubernetes gerenciado.

Uso comum:

```text
Cloud Load Balancer
↓
GKE Ingress
↓
Service
↓
Pods
↓
Cloud SQL / Redis / Cloud Storage
```

## Firewall Rules

Firewall no GCP é definido na VPC.

Exemplo:

| Regra | Origem | Porta |
| --- | --- | --- |
| permitir HTTP | `0.0.0.0/0` | 80 |
| permitir HTTPS | `0.0.0.0/0` | 443 |
| permitir SSH | seu IP | 22 |

## Quando escolher GCP

- foco forte em Kubernetes com GKE
- workloads de dados e analytics
- integração com BigQuery
- preferência por rede global simples de modelar

## Mini-desafio

1. Compare EKS com GKE.
2. Desenhe uma aplicação em GKE com Cloud SQL.
3. Defina firewall permitindo `80`, `443` e SSH só do seu IP.
4. Explique por que subnet regional muda o desenho da rede.
