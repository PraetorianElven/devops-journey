# Projeto de Validação de Conectividade entre Aplicação Flask, PostgreSQL e NGINX

## Objetivo

Criar uma aplicação simples em Python para validar a comunicação com um banco PostgreSQL, containerizar a aplicação utilizando Docker, orquestrar os serviços com Docker Compose e disponibilizar o acesso através de um NGINX atuando como Proxy Reverso.

---

# Arquitetura Final

```text
                +-------------+
                |   Usuário   |
                +------+------+
                       |
                       |
                 Porta 8989
                       |
                       v
                +-------------+
                |    NGINX    |
                | Proxy       |
                | Reverso     |
                +------+------+
                       |
                       |
                       v
                +-------------+
                | Flask App   |
                | Porta 3000  |
                +------+------+
                       |
                       |
                       v
                +-------------+
                | PostgreSQL  |
                | Porta 5432  |
                +-------------+
```

---

# Etapa 1 - Desenvolvimento da Aplicação Flask

Foi criada uma aplicação Flask contendo dois endpoints:

## Endpoint de Health Check

Responsável por validar se a aplicação está operacional.

```python
@app.get("/health")
def health():
    return {"status": "ok"}
```

Exemplo de resposta:

```json
{
  "status": "ok"
}
```

---

## Endpoint de Verificação do Banco

Responsável por:

- Abrir conexão com PostgreSQL
- Executar uma consulta simples (`SELECT 1`)
- Retornar o resultado da consulta

```python
@app.get("/db-health")
def db_health():
    try:
        conn = psycopg2.connect(
            host=DB_HOST,
            port=DB_PORT,
            dbname=DB_NAME,
            user=DB_USER,
            password=DB_PASSWORD,
            connect_timeout=5
        )

        cursor = conn.cursor()
        cursor.execute("SELECT 1")
        result = cursor.fetchone()

        cursor.close()
        conn.close()

        return jsonify({
            "status": "healthy",
            "database": "reachable",
            "query_result": result[0]
        })

    except Exception as e:
        return jsonify({
            "status": "unhealthy",
            "error": str(e)
        }), 500
```

Exemplo de resposta:

```json
{
  "status": "healthy",
  "database": "reachable",
  "query_result": 1
}
```

---

# Etapa 2 - Definição das Dependências

Arquivo:

```text
requirements.txt
```

Conteúdo:

```txt
flask==2.0.1
psycopg2-binary==2.9.1
werkzeug==2.0.1
```

Bibliotecas utilizadas:

| Biblioteca | Finalidade |
|------------|------------|
| Flask | Framework Web |
| psycopg2-binary | Conexão com PostgreSQL |
| Werkzeug | Dependência do Flask |

---

# Etapa 3 - Build da Aplicação

Inicialmente foi realizado o build da imagem Docker da aplicação para validar seu funcionamento de forma isolada.

Objetivos desta etapa:

- Garantir que a aplicação iniciava corretamente
- Validar instalação das dependências
- Confirmar funcionamento do endpoint `/health`

Exemplo:

```bash
docker build -t flask-app .
docker run -p 3000:3000 flask-app
```

Teste realizado:

```bash
curl http://localhost:3000/health
```

---

# Etapa 4 - Integração com PostgreSQL

Após validar a aplicação individualmente, foi criado um ambiente composto por:

- Aplicação Flask
- Banco PostgreSQL

utilizando Docker Compose.

Nesta etapa foi realizada a configuração das variáveis de ambiente responsáveis pela conexão com o banco.

```yaml
environment:
  DB_HOST: db
  DB_PORT: 5432
  DB_NAME: postgres
  DB_USER: postgres
  DB_PASSWORD: password
```

Observação:

O hostname utilizado foi:

```text
db
```

pois dentro da rede Docker os containers se comunicam através do nome do serviço.

---

# Etapa 5 - Validação da Comunicação

Após subir o ambiente:

```bash
docker compose up -d
```

foi realizado o teste do endpoint:

```bash
curl http://localhost:3000/db-health
```

Objetivo:

Validar que:

- A aplicação conseguia resolver o hostname do banco
- A autenticação estava correta
- O PostgreSQL aceitava conexões
- A consulta SQL era executada com sucesso

Resultado esperado:

```json
{
  "status": "healthy",
  "database": "reachable",
  "query_result": 1
}
```

---

# Etapa 6 - Remoção da Exposição Direta da Aplicação

Após validar a comunicação entre aplicação e banco de dados, foi removida a exposição da porta da aplicação para o host.

Antes:

```yaml
ports:
  - "3000:3000"
```

Após:

```yaml
Sem exposição externa
```

Motivo:

A aplicação não deve ser acessada diretamente pelos usuários.

O acesso deve ocorrer apenas através do NGINX.

---

# Etapa 7 - Implementação do Proxy Reverso

Foi adicionado um container NGINX para atuar como ponto único de entrada da aplicação.

Responsabilidades do NGINX:

- Receber o tráfego externo
- Encaminhar as requisições para a aplicação Flask
- Ocultar a aplicação da internet
- Centralizar futuras configurações de segurança

---

## Configuração do NGINX

Arquivo:

```text
nginx/default.conf
```

Conteúdo:

```nginx
server {
    listen 80;

    location / {
        proxy_pass http://web:3000;

        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

---

## Fluxo de Comunicação

```text
Usuário
   |
   |
   v
NGINX
   |
   |
   v
Flask
   |
   |
   v
PostgreSQL
```

---

# Etapa 8 - Docker Compose Final

```yaml
services:
  web:
    build: .

    environment:
      DB_HOST: db
      DB_PORT: 5432
      DB_NAME: postgres
      DB_USER: postgres
      DB_PASSWORD: password

    depends_on:
      - db

    networks:
      - app-network

  db:
    image: postgres:13

    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: password
      POSTGRES_DB: postgres

    networks:
      - app-network

  nginx:
    image: nginx:latest

    ports:
      - "8989:80"

    volumes:
      - ./nginx/default.conf:/etc/nginx/conf.d/default.conf

    depends_on:
      - web

    networks:
      - app-network

networks:
  app-network:
    driver: bridge
```

---

# Testes Finais

## Validar Aplicação

```bash
curl http://localhost:8989/health
```

Retorno esperado:

```json
{
  "status": "ok"
}
```

---

## Validar Banco de Dados

```bash
curl http://localhost:8989/db-health
```

Retorno esperado:

```json
{
  "status": "healthy",
  "database": "reachable",
  "query_result": 1
}
```

---

# Conclusão

Durante a implementação foram executadas as seguintes etapas:

1. Desenvolvimento da aplicação Flask.
2. Criação do endpoint de Health Check.
3. Criação do endpoint de validação do PostgreSQL.
4. Containerização da aplicação.
5. Teste isolado da imagem Docker.
6. Integração com PostgreSQL utilizando Docker Compose.
7. Validação da conectividade entre aplicação e banco.
8. Remoção da exposição direta da aplicação.
9. Implementação do NGINX como Proxy Reverso.
10. Publicação do ambiente completo utilizando Docker Compose.

O ambiente final reproduz uma arquitetura amplamente utilizada em ambientes corporativos, onde um Proxy Reverso recebe o tráfego externo e encaminha as requisições para aplicações executando em containers isolados dentro de uma rede privada.