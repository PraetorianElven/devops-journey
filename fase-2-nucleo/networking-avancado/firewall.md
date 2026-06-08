# Firewall — iptables, UFW e Security Groups

## Objetivo

Entender como controlar tráfego de entrada e saída usando firewall local e firewall de cloud.

## Conceito

Firewall decide se um pacote pode passar.

```text
Cliente
↓
Firewall
↓
Servidor
↓
Aplicação
```

## Ver IP, rotas e portas

```bash
ip addr
ip route
ss -tunlp
```

## UFW

UFW é uma camada mais simples para configurar firewall no Linux.

Status:

```bash
sudo ufw status verbose
```

Liberar SSH:

```bash
sudo ufw allow 22/tcp
```

Liberar HTTP e HTTPS:

```bash
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
```

Ativar:

```bash
sudo ufw enable
```

Remover regra:

```bash
sudo ufw status numbered
sudo ufw delete NUMERO
```

## iptables

iptables é mais baixo nível que UFW.

Listar regras:

```bash
sudo iptables -L -n -v
```

Permitir porta 80:

```bash
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT
```

Bloquear IP:

```bash
sudo iptables -A INPUT -s 203.0.113.10 -j DROP
```

## Security Groups em cloud

Na AWS, Security Group funciona como firewall da instância, load balancer ou banco.

Exemplo comum:

| Tipo | Origem | Porta | Motivo |
| --- | --- | --- | --- |
| SSH | seu IP | 22 | administração |
| HTTP | internet | 80 | site |
| HTTPS | internet | 443 | site seguro |
| Postgres | security group da app | 5432 | banco só para aplicação |

Regra ruim:

```text
0.0.0.0/0 → 22
```

Isso expõe SSH para a internet inteira.

## Mini-desafio

1. Liste portas abertas com `ss -tunlp`.
2. Libere `80` e `443` no UFW.
3. Bloqueie um IP fictício com iptables.
4. Desenhe as regras de Security Group para app e banco.
