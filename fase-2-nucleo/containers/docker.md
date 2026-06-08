# Docker — Imagens, Containers, Dockerfile, Volumes e Redes

## Objetivo

Entender Docker como ferramenta para empacotar e executar aplicações em containers.

Container não é uma máquina virtual completa. Ele é um processo isolado que usa o kernel do host, com filesystem, rede, variáveis e limites próprios.

```text
Imagem
↓ docker run
Container
↓ processo rodando
Aplicação
```

## Instalação e serviço

```bash
sudo apt install docker.io
sudo systemctl status docker
docker version
docker info
```

## Conceitos principais

| Conceito | Significado |
| --- | --- |
| imagem | pacote imutável com app, libs e comandos |
| container | execução de uma imagem |
| Dockerfile | receita para construir uma imagem |
| volume | persistência fora do ciclo de vida do container |
| network | comunicação entre containers |
| registry | local onde imagens são publicadas, como Docker Hub |

## Rodando um container

```bash
docker run --name web -d -p 8080:80 nginx
```

O que aconteceu:

| Parte | Explicação |
| --- | --- |
| `--name web` | nome do container |
| `-d` | roda em background |
| `-p 8080:80` | porta 8080 do host aponta para porta 80 do container |
| `nginx` | imagem usada |

Teste:

```bash
curl http://localhost:8080
docker ps
docker logs web
docker stop web
docker rm web
```

## Dockerfile real

Estrutura:

```text
app/
├── app.py
├── requirements.txt
└── Dockerfile
```

`app.py`:

```python
from flask import Flask

app = Flask(__name__)

@app.get("/health")
def health():
    return {"status": "ok"}

app.run(host="0.0.0.0", port=3000)
```

`requirements.txt`:

```text
flask
```

`Dockerfile`:

```dockerfile
FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .

EXPOSE 3000

CMD ["python", "app.py"]
```

Build:

```bash
docker build -t minha-api:1.0 .
```

Run:

```bash
docker run --name api -d -p 3000:3000 minha-api:1.0
curl http://localhost:3000/health
```

## Camadas da imagem

Cada instrução importante do Dockerfile cria uma camada. Por isso copiamos `requirements.txt` antes do código.

Quando só o `app.py` muda, o Docker reaproveita a camada do `pip install`, deixando o build mais rápido.

## Volumes

Sem volume, dados gravados dentro do container somem quando o container é removido.

Criar volume:

```bash
docker volume create postgres_data
docker volume ls
```

Usar volume:

```bash
docker run --name pg -d \
  -e POSTGRES_PASSWORD=senha123 \
  -v postgres_data:/var/lib/postgresql/data \
  postgres:16
```

Inspecionar:

```bash
docker volume inspect postgres_data
```

## Redes

Containers na mesma rede Docker conseguem se acessar pelo nome.

```bash
docker network create app_net

docker run --name redis -d --network app_net redis:7
docker run --name app -d --network app_net minha-api:1.0
```

Dentro da aplicação, o host do Redis seria:

```text
redis:6379
```

## Comandos essenciais

```bash
docker ps
docker ps -a
docker images
docker logs nome_container
docker exec -it nome_container bash
docker inspect nome_container
docker stop nome_container
docker rm nome_container
docker rmi nome_imagem
```

## Troubleshooting

| Sintoma | Verificação |
| --- | --- |
| container saiu sozinho | `docker logs nome` |
| porta não responde | `docker ps` e conferir `PORTS` |
| imagem não builda | olhar a linha exata do erro no Dockerfile |
| app não conecta no banco | conferir se estão na mesma network |
| dados sumiram | conferir se estava usando volume |

## Mini-desafio

1. Crie uma API simples com endpoint `/health`.
2. Escreva um Dockerfile.
3. Faça build da imagem.
4. Rode o container expondo a porta `3000`.
5. Veja logs, entre no container e remova tudo no final.
