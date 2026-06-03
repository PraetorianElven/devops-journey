# Redis — Cache, Estruturas e Uso em Aplicações

## Objetivo

Entender Redis como cache em memória, armazenamento temporário e apoio para sessões, filas simples e rate limit.

## Instalação e teste

```bash
sudo apt install redis-server
sudo systemctl status redis-server
redis-cli ping
```

Resposta esperada:

```text
PONG
```

## Configuração

```text
/etc/redis/redis.conf
```

Porta padrão:

```text
6379
```

## Comandos básicos

```bash
redis-cli
SET nome paulo
GET nome
DEL nome
EXISTS nome
```

## Chave com expiração

```bash
SET token abc123 EX 60
TTL token
GET token
```

Uso real: cache de resposta, token temporário, código de verificação.

## Cache de API

Fluxo:

```text
requisição chega
↓
consulta Redis
↓
se existe: responde rápido
↓
se não existe: consulta banco, salva no Redis, responde
```

Pseudo-código:

```text
cache_key = "produto:123"
valor = redis.get(cache_key)

se valor existir:
    retorna valor

produto = banco.buscar_produto(123)
redis.set(cache_key, produto, expiracao=300)
retorna produto
```

## Sessão

Guardar sessão no Redis evita prender usuário a uma instância específica da aplicação.

```text
App 1 ┐
App 2 ├── Redis sessões
App 3 ┘
```

## Cuidados

| Cuidados | Por quê |
| --- | --- |
| não expor Redis para internet | Redis sem proteção vira risco crítico |
| usar senha/rede privada | reduz acesso indevido |
| definir TTL em cache | evita memória crescer sem controle |
| não tratar Redis como banco principal sem entender persistência | ele é memória primeiro |

## Mini-desafio

1. Salve uma chave simples.
2. Salve uma chave com TTL de 30 segundos.
3. Simule cache de produto com chave `produto:1`.
4. Veja o TTL diminuindo.
5. Apague a chave e confirme que sumiu.
