# Docker Compose — Orquestração Local Multi-container

## Objetivo

Usar Docker Compose para subir vários containers que fazem parte do mesmo ambiente: aplicação, banco, cache, fila e ferramentas auxiliares.

Compose é ideal para desenvolvimento local e laboratórios.

## Arquivo principal

```text
docker-compose.yml
```

Estrutura comum:

```text
projeto/
├── Dockerfile
├── app.py
└── docker-compose.yml
```

## Exemplo com app, Redis e Postgres

```yaml
services:
  app:
    build: .
    ports:
      - "3000:3000"
    environment:
      REDIS_HOST: redis
      DATABASE_URL: postgres://postgres:senha123@postgres:5432/app
    depends_on:
      - redis
      - postgres

  redis:
    image: redis:7
    ports:
      - "6379:6379"

  postgres:
    image: postgres:16
    environment:
      POSTGRES_DB: app
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: senha123
    volumes:
      - postgres_data:/var/lib/postgresql/data

volumes:
  postgres_data:
```

Subir:

```bash
docker compose up -d
```

Ver status:

```bash
docker compose ps
```

Logs:

```bash
docker compose logs -f app
```

Derrubar:

```bash
docker compose down
```

Derrubar removendo volumes:

```bash
docker compose down -v
```

## Comunicação entre serviços

No Compose, cada serviço vira um nome DNS dentro da rede do projeto.

Exemplos:

| Serviço | Endereço usado por outro container |
| --- | --- |
| `redis` | `redis:6379` |
| `postgres` | `postgres:5432` |
| `app` | `app:3000` |

Não use `localhost` para acessar outro container. Dentro de um container, `localhost` é o próprio container.

## `depends_on`

`depends_on` controla ordem de inicialização, mas não garante que o serviço já está pronto para receber conexão.

Exemplo: o Postgres pode ter iniciado, mas ainda estar carregando dados.

Para ambientes mais robustos, use `healthcheck`:

```yaml
services:
  postgres:
    image: postgres:16
    environment:
      POSTGRES_PASSWORD: senha123
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 5s
      timeout: 3s
      retries: 10
```

## Variáveis com `.env`

`.env`:

```env
POSTGRES_PASSWORD=senha123
APP_PORT=3000
```

`docker-compose.yml`:

```yaml
services:
  app:
    build: .
    ports:
      - "${APP_PORT}:3000"

  postgres:
    image: postgres:16
    environment:
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
```

## Comandos úteis

```bash
docker compose config
docker compose up -d --build
docker compose restart app
docker compose exec app bash
docker compose logs -f
docker compose down
```

## Mini-desafio

1. Crie um `docker-compose.yml` com `app`, `redis` e `postgres`.
2. Faça a aplicação usar `redis` como hostname.
3. Adicione volume ao Postgres.
4. Suba o ambiente.
5. Remova os containers mantendo o volume.
6. Suba de novo e confirme que o volume persistiu.
