# Load Balancer — Round-robin e Least Connections

## Objetivo

Entender como distribuir tráfego entre múltiplas instâncias de uma aplicação.

```text
Cliente
↓
Load Balancer
↓        ↓
App 1    App 2
```

## Por que usar

- distribuir carga
- aumentar disponibilidade
- permitir manutenção sem derrubar tudo
- expor um único endpoint para várias instâncias

## Round-robin

Round-robin distribui requisições em sequência.

```text
requisição 1 → app1
requisição 2 → app2
requisição 3 → app1
requisição 4 → app2
```

Exemplo Nginx:

```nginx
upstream minha_api {
    server 127.0.0.1:3001;
    server 127.0.0.1:3002;
}

server {
    listen 80;
    server_name api.local;

    location / {
        proxy_pass http://minha_api;
    }
}
```

## Least connections

Least connections envia a próxima requisição para o backend com menos conexões ativas.

```nginx
upstream minha_api {
    least_conn;

    server 127.0.0.1:3001;
    server 127.0.0.1:3002;
}
```

## Health check

Load balancer precisa saber se um backend está saudável.

Exemplo endpoint:

```text
GET /health
200 OK
```

Em clouds, ALB/NLB fazem health checks configuráveis. Em Nginx open source, o comportamento é mais simples e falhas são percebidas durante tentativas de conexão.

## Sticky session

Sticky session mantém um usuário preso ao mesmo backend.

Pode ser útil para sistemas legados com sessão em memória, mas o ideal moderno é guardar sessão fora da aplicação, como Redis.

## Mini-desafio

1. Rode duas instâncias da mesma API em portas diferentes.
2. Configure um `upstream` no Nginx.
3. Faça 10 requisições e veja a distribuição.
4. Derrube uma instância.
5. Observe o comportamento nos logs.
