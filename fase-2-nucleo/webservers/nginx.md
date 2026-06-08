# Nginx — Virtual Hosts e Proxy Reverso

## Objetivo

Estudar Nginx como servidor web e como proxy reverso na frente de uma aplicação.

No mundo real, o Nginx geralmente recebe o tráfego HTTP/HTTPS primeiro e encaminha para uma aplicação que roda em outra porta, como Node.js, Python, Java ou Go.

```text
Internet
↓
Nginx :80/:443
↓
Aplicação local :3000
```

## Instalação

```bash
sudo apt update
sudo apt install nginx
sudo systemctl status nginx
```

Verifique se ele está escutando porta 80:

```bash
ss -tunlp | grep nginx
```

## Arquivos importantes

| Caminho | Função |
| --- | --- |
| `/etc/nginx/nginx.conf` | configuração principal |
| `/etc/nginx/sites-available/` | arquivos de sites disponíveis |
| `/etc/nginx/sites-enabled/` | links dos sites ativos |
| `/var/log/nginx/access.log` | log de acessos |
| `/var/log/nginx/error.log` | log de erros |

## Virtual Host simples

Crie um arquivo:

```bash
sudo nano /etc/nginx/sites-available/api.conf
```

Exemplo:

```nginx
server {
    listen 80;
    server_name api.meusite.local;

    root /var/www/api;
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }
}
```

Ative o site:

```bash
sudo ln -s /etc/nginx/sites-available/api.conf /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

## Proxy reverso

Suponha que uma API esteja rodando localmente na porta 3000:

```bash
curl http://127.0.0.1:3000/health
```

Configuração do Nginx:

```nginx
server {
    listen 80;
    server_name api.meusite.local;

    location / {
        proxy_pass http://127.0.0.1:3000;
        proxy_http_version 1.1;

        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

## Por que os headers importam

| Header | Para que serve |
| --- | --- |
| `Host` | preserva o domínio acessado pelo usuário |
| `X-Real-IP` | envia o IP real do cliente para a aplicação |
| `X-Forwarded-For` | mantém a cadeia de proxies até o cliente |
| `X-Forwarded-Proto` | informa se o acesso original foi `http` ou `https` |

Sem esses headers, a aplicação pode registrar tudo como vindo de `127.0.0.1`, gerar links HTTP quando deveria gerar HTTPS, ou aplicar regras erradas por domínio.

## Timeout e upload

Exemplo comum para APIs que recebem arquivos ou processam requisições longas:

```nginx
server {
    listen 80;
    server_name api.meusite.local;

    client_max_body_size 20m;

    location / {
        proxy_pass http://127.0.0.1:3000;
        proxy_connect_timeout 10s;
        proxy_send_timeout 60s;
        proxy_read_timeout 60s;
    }
}
```

## Comandos de troubleshooting

```bash
sudo nginx -t
sudo systemctl status nginx
sudo journalctl -u nginx -n 100
sudo tail -f /var/log/nginx/access.log
sudo tail -f /var/log/nginx/error.log
curl -I http://localhost
```

## Erros comuns

| Erro | Causa provável | Como verificar |
| --- | --- | --- |
| `502 Bad Gateway` | aplicação backend fora do ar | `curl http://127.0.0.1:3000` |
| `403 Forbidden` | permissão ou `index` ausente | logs em `/var/log/nginx/error.log` |
| site errado responde | conflito em `server_name` ou site default ativo | `ls -l /etc/nginx/sites-enabled/` |
| reload falha | sintaxe inválida | `sudo nginx -t` |

## Mini-desafio

1. Suba uma aplicação simples na porta `3000`.
2. Crie um virtual host `api.local`.
3. Configure Nginx como proxy reverso para `127.0.0.1:3000`.
4. Teste com `curl -H "Host: api.local" http://127.0.0.1`.
5. Quebre de propósito o backend e veja o erro `502`.
