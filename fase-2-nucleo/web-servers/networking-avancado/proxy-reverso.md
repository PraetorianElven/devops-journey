# Proxy Reverso — Nginx, Headers e Backend

## Objetivo

Entender proxy reverso como camada entre cliente e aplicação.

```text
Cliente
↓
Proxy reverso
↓
Backend
```

O cliente não acessa diretamente a aplicação na porta `3000`. Ele acessa o proxy na porta `80` ou `443`.

## Exemplo com Nginx

```nginx
server {
    listen 80;
    server_name api.local;

    location / {
        proxy_pass http://127.0.0.1:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

## Headers importantes

| Header | Importância |
| --- | --- |
| `Host` | backend sabe qual domínio foi chamado |
| `X-Real-IP` | backend sabe o IP real do cliente |
| `X-Forwarded-For` | mantém cadeia de proxies |
| `X-Forwarded-Proto` | backend sabe se origem era HTTP ou HTTPS |

## Proxy por caminho

Um domínio pode mandar caminhos diferentes para serviços diferentes.

```nginx
server {
    listen 80;
    server_name app.local;

    location /api/ {
        proxy_pass http://127.0.0.1:3000/;
    }

    location /admin/ {
        proxy_pass http://127.0.0.1:4000/;
    }
}
```

## Erros comuns

| Erro | Causa provável |
| --- | --- |
| `502 Bad Gateway` | backend fora do ar |
| `504 Gateway Timeout` | backend demorou demais |
| redirect infinito | app não entende HTTPS original |
| IP real perdido | falta `X-Real-IP` ou `X-Forwarded-For` |

## Mini-desafio

1. Suba dois backends: um na porta `3000`, outro na `4000`.
2. Configure `/api/` para `3000`.
3. Configure `/admin/` para `4000`.
4. Teste com `curl`.
5. Veja os logs do Nginx.
