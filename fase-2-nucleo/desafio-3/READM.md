# Desafio 3 – Pipeline CI/CD Completa com GitHub Actions

## Objetivo

Implementar uma pipeline CI/CD utilizando GitHub Actions que execute automaticamente as seguintes etapas:

- Execução de testes automatizados
- Build da imagem Docker
- Publicação da imagem em um Registry (Docker Hub)
- Envio de notificação de sucesso ou falha
- Disparo automático a cada push na branch `main`

---

# Estrutura do Projeto

Para atender aos requisitos do desafio, foi criado um repositório dedicado chamado:

```text
desafio-3
```

Estrutura do projeto:

```text
desafio-3/
├── .github/
│   └── workflows/
│       └── ci-cd.yml
├── app.py
├── test_app.py
├── Dockerfile
├── requirements.txt
└── README.md
```

---

# Aplicação

Foi desenvolvida uma aplicação simples utilizando Flask com dois endpoints:

## Endpoint Principal

```http
GET /
```

Resposta:

```json
{
  "message": "Hello DevOps"
}
```

## Endpoint Health Check

```http
GET /health
```

Resposta:

```json
{
  "status": "ok"
}
```

Arquivo:

```python
from flask import Flask, jsonify

app = Flask(__name__)

@app.route("/")
def home():
    return jsonify({
        "message": "Hello DevOps"
    })

@app.route("/health")
def health():
    return jsonify({
        "status": "ok"
    })

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=3000)
```

---

# Testes Automatizados

Para validar a aplicação durante a execução da pipeline, foram implementados testes automatizados utilizando Pytest.

Arquivo:

```python
from app import app

def test_home():
    client = app.test_client()

    response = client.get("/")

    assert response.status_code == 200
    assert response.get_json()["message"] == "Hello DevOps"

def test_health():
    client = app.test_client()

    response = client.get("/health")

    assert response.status_code == 200
    assert response.get_json()["status"] == "ok"
```

Os testes garantem:

- Disponibilidade dos endpoints
- Retorno HTTP esperado
- Conteúdo da resposta correto

---

# Dependências

Arquivo:

```text
Flask==2.0.1
pytest==6.2.4
werkzeug==2.0.1
```

Instalação local:

```bash
pip install -r requirements.txt
```

---

# Containerização

A aplicação foi containerizada utilizando Docker.

Arquivo:

```dockerfile
FROM python:3.12-slim

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 3000

CMD ["python", "app.py"]
```

---

# Build Local

Construção da imagem:

```bash
docker build -t flask-devops-demo .
```

Execução do container:

```bash
docker run -p 3000:3000 flask-devops-demo
```

Teste dos endpoints:

```bash
curl localhost:3000
```

```bash
curl localhost:3000/health
```

---

# Docker Hub

Foi utilizado o Docker Hub como Registry para armazenamento das imagens geradas pela pipeline.

As credenciais foram armazenadas utilizando GitHub Secrets.

Secrets configurados:

```text
DOCKERHUB_USERNAME
DOCKERHUB_TOKEN
DISCORD_WEBHOOK_URL
```

---

# Pipeline CI/CD

A pipeline foi implementada utilizando GitHub Actions.

Localização:

```text
.github/workflows/ci-cd.yml
```

Trigger:

```yaml
on:
  push:
    branches:
      - main
```

A execução ocorre automaticamente sempre que um push é realizado na branch principal.

---

# Fluxo da Pipeline

```text
Push na Branch Main
        │
        ▼
Checkout do Código
        │
        ▼
Instalação das Dependências
        │
        ▼
Execução dos Testes
        │
        ▼
Build da Imagem Docker
        │
        ▼
Login no Docker Hub
        │
        ▼
Push da Imagem
        │
        ▼
Notificação Discord
```

---

# Etapa 1 - Testes

A primeira etapa da pipeline realiza:

```yaml
pip install -r requirements.txt
pytest -v
```

Objetivo:

- Garantir que a aplicação esteja funcional
- Impedir publicação de imagens com falhas

Caso os testes falhem:

```text
Pipeline interrompida
Build cancelado
Push cancelado
Notificação de falha enviada
```

---

# Etapa 2 - Build da Imagem

Após a validação dos testes, é realizado o build da imagem Docker.

Tags geradas:

```text
latest
github.sha
```

Exemplo:

```text
usuario/flask-devops-demo:latest

usuario/flask-devops-demo:a1b2c3d4
```

---

# Etapa 3 - Publicação da Imagem

Autenticação no Docker Hub:

```yaml
uses: docker/login-action@v3
```

Publicação:

```yaml
uses: docker/build-push-action@v6
```

A imagem é enviada automaticamente para o Docker Hub após a conclusão dos testes.

---

# Etapa 4 - Notificação

Foi implementada integração com Discord utilizando Webhook.

Objetivos:

- Informar sucesso da pipeline
- Informar falhas da pipeline
- Facilitar acompanhamento do processo de CI/CD

---

## Notificação de Sucesso

Exemplo:

```text
✅ PIPELINE EXECUTADA COM SUCESSO

Repositório: desafio-3
Branch: main
Commit: a1b2c3d

Imagem publicada no Docker Hub com sucesso.
```

---

## Notificação de Falha

Exemplo:

```text
❌ PIPELINE FALHOU

Repositório: desafio-3
Branch: main
Commit: a1b2c3d

Test Result: failure
Build Result: skipped
```

---

# Resultado Obtido

A solução implementada atende integralmente aos requisitos propostos:

| Requisito | Status |
|------------|---------|
| Execução de testes | ✅ |
| Build da imagem Docker | ✅ |
| Publicação em Registry | ✅ |
| Docker Hub | ✅ |
| Notificação de sucesso | ✅ |
| Notificação de falha | ✅ |
| GitHub Actions | ✅ |
| Trigger em push na main | ✅ |

---

# Conclusão

Foi implementada uma pipeline CI/CD completa utilizando GitHub Actions, Docker e Docker Hub.

A solução garante:

- Validação automática da aplicação através de testes
- Geração padronizada de imagens Docker
- Publicação automática em Registry
- Visibilidade operacional através de notificações em tempo real no Discord

Essa abordagem segue práticas comuns utilizadas em ambientes DevOps e SRE para automação de entrega contínua de aplicações containerizadas.