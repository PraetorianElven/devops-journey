# Redes — OSI, DNS e Fundamentos

## Modelo OSI (visão prática)

### 7 camadas:

1. Física  
2. Enlace  
3. Rede  
4. Transporte  
5. Sessão  
6. Apresentação  
7. Aplicação  

---

## Forma fácil de entender:

### Exemplo navegador acessando google.com:

- Aplicação → HTTP/HTTPS
- Transporte → TCP/UDP
- Rede → IP
- Enlace → MAC
- Física → cabo/Wi-Fi

---

## Camadas mais importantes para DevOps/SRE

### Camada 3 — Rede
- IP
- Roteamento
- ICMP (`ping`)

### Camada 4 — Transporte
- TCP
- UDP
- Portas

### Camada 7 — Aplicação
- HTTP
- HTTPS
- DNS

---

## TCP vs UDP

### TCP:
- Confiável
- Confirma entrega
- Exemplo: SSH, HTTPS

### UDP:
- Mais rápido
- Sem garantia
- Exemplo: DNS, streaming

---

## Portas comuns

```txt
22   SSH
53   DNS
80   HTTP
443  HTTPS
3306 MySQL
5432 PostgreSQL
6379 Redis
8080 Apps/Web



# DNS (Domain Name System)
Função:

Traduz nome para IP

Exemplo:
google.com -> 142.250.x.x

Comandos:
nslookup google.com
dig google.com
host google.com

/etc/hosts

Arquivo local para resolução manual.

Exemplo:
192.168.31.79 minha-api.local


Caminho:
/etc/hosts
Teste:
ping minha-api.local
nip.io

Permite resolver IP por nome sem configurar DNS.

Exemplo:
192.168.31.79.nip.io

Resolve automaticamente para:

192.168.31.79
Uso comum:
Kubernetes Ingress
Labs locais
Testes HTTP
HTTP vs HTTPS
HTTP:
Porta 80
Sem criptografia
HTTPS:
Porta 443
TLS/SSL
Seguro
Ferramentas úteis
ping dominio
curl -I dominio
traceroute dominio
ss -tulnp
netstat -tulnp
ip a
Diagnóstico rápido
Sem internet:
ip a
ping gateway
ping 8.8.8.8
ping google.com
Se IP responde mas domínio não:

Problema provável = DNS

Resumo prático
IP = endereço
DNS = nome traduzido
Porta = serviço
TCP = confiável
UDP = rápido
/etc/hosts = DNS manual
nip.io = DNS automático para lab


