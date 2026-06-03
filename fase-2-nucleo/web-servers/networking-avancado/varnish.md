# Varnish — Caching Server HTTP

## Objetivo

Entender Varnish como cache HTTP na frente de aplicações web.

Varnish é diferente do Redis. Redis é cache genérico de chave/valor. Varnish é cache de respostas HTTP.

```text
Cliente
↓
Varnish
↓
Nginx/App
```

## Quando usar

- páginas públicas com alto volume
- APIs GET cacheáveis
- reduzir carga no backend
- acelerar resposta de conteúdo repetido

Não é indicado para respostas privadas sem cuidado, como páginas com dados de usuário logado.

## Exemplo de fluxo

Primeira requisição:

```text
cliente pede /produtos
↓
Varnish não tem cache
↓
busca no backend
↓
salva resposta
↓
responde cliente
```

Próxima requisição:

```text
cliente pede /produtos
↓
Varnish encontra cache
↓
responde sem chamar backend
```

## VCL básico

Arquivo comum:

```text
/etc/varnish/default.vcl
```

Exemplo:

```vcl
vcl 4.1;

backend default {
    .host = "127.0.0.1";
    .port = "8080";
}

sub vcl_recv {
    if (req.method != "GET" && req.method != "HEAD") {
        return (pass);
    }
}

sub vcl_backend_response {
    set beresp.ttl = 5m;
}
```

## Headers úteis

| Header | Uso |
| --- | --- |
| `Cache-Control` | define política de cache |
| `Age` | idade da resposta em cache |
| `X-Cache` | muitas instalações adicionam HIT/MISS |

## Cuidados

- não cachear resposta com dados privados
- respeitar autenticação
- definir TTL adequado
- criar estratégia de invalidação
- observar headers do backend

## Mini-desafio

1. Coloque uma aplicação na porta `8080`.
2. Configure Varnish na frente.
3. Faça duas requisições iguais.
4. Compare tempo de resposta.
5. Altere TTL e observe o comportamento.
