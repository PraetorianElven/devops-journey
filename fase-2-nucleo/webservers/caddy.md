# Caddy — HTTPS Automático e Config Simples

## Objetivo

Estudar Caddy como alternativa moderna ao Nginx e Apache, com configuração curta e HTTPS automático.

Caddy é muito usado quando você quer publicar serviços rapidamente com TLS automático via Let's Encrypt.

## Instalação

Em Debian/Ubuntu, siga a instalação oficial do pacote da distribuição usada. Depois valide:

```bash
caddy version
systemctl status caddy
```

## Arquivo principal

```text
/etc/caddy/Caddyfile
```

O Caddyfile é a configuração principal. Ele costuma ser bem menor que uma configuração equivalente em Nginx.

## Site estático

```caddyfile
site.local {
    root * /var/www/site
    file_server
}
```

Teste local:

```bash
curl -H "Host: site.local" http://127.0.0.1
```

## Proxy reverso

Aplicação rodando em `127.0.0.1:3000`:

```caddyfile
api.local {
    reverse_proxy 127.0.0.1:3000
}
```

Fluxo:

```text
Cliente
↓
Caddy
↓
Aplicação :3000
```

## HTTPS automático

Quando você usa um domínio real apontando para o servidor, Caddy tenta emitir e renovar certificados automaticamente.

Exemplo:

```caddyfile
api.exemplo.com {
    reverse_proxy 127.0.0.1:3000
}
```

Requisitos para HTTPS automático funcionar:

- domínio apontando para o IP do servidor
- portas `80` e `443` liberadas
- Caddy acessível pela internet
- sem outro serviço ocupando as portas `80` e `443`

## Headers no proxy

Caddy já envia headers importantes por padrão em `reverse_proxy`, como informações do host e IP do cliente. Ainda assim, você pode customizar:

```caddyfile
api.local {
    reverse_proxy 127.0.0.1:3000 {
        header_up X-Real-IP {remote_host}
    }
}
```

## Validar e recarregar

```bash
sudo caddy validate --config /etc/caddy/Caddyfile
sudo systemctl reload caddy
sudo journalctl -u caddy -n 100
```

## Quando escolher Caddy

| Cenário | Caddy faz sentido? |
| --- | --- |
| publicar API simples com HTTPS | sim |
| laboratório rápido | sim |
| muitas regras legadas complexas | talvez Nginx/Apache seja melhor |
| hosting PHP tradicional | Apache ou Nginx costumam aparecer mais |

## Mini-desafio

1. Crie um Caddyfile para `api.local`.
2. Faça proxy para `127.0.0.1:3000`.
3. Valide a configuração.
4. Recarregue o serviço.
5. Teste com `curl -H "Host: api.local" http://127.0.0.1`.
