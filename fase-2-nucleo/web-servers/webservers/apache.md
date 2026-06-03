# Apache — Configuração Básica e Módulos

## Objetivo

Estudar Apache como servidor web tradicional, entendendo configuração básica, virtual hosts e módulos.

Apache é muito usado em hospedagens, aplicações PHP, sistemas legados e ambientes onde módulos como `rewrite`, `proxy` e `ssl` são importantes.

## Instalação

```bash
sudo apt update
sudo apt install apache2
sudo systemctl status apache2
```

Ver portas abertas:

```bash
ss -tunlp | grep apache
```

## Arquivos importantes

| Caminho | Função |
| --- | --- |
| `/etc/apache2/apache2.conf` | configuração global |
| `/etc/apache2/sites-available/` | virtual hosts disponíveis |
| `/etc/apache2/sites-enabled/` | virtual hosts ativos |
| `/etc/apache2/mods-available/` | módulos disponíveis |
| `/etc/apache2/mods-enabled/` | módulos ativos |
| `/var/log/apache2/access.log` | log de acessos |
| `/var/log/apache2/error.log` | log de erros |

## Virtual Host estático

Crie o diretório do site:

```bash
sudo mkdir -p /var/www/site
echo "site apache" | sudo tee /var/www/site/index.html
```

Crie o virtual host:

```bash
sudo nano /etc/apache2/sites-available/site.conf
```

Conteúdo:

```apache
<VirtualHost *:80>
    ServerName site.local
    DocumentRoot /var/www/site

    ErrorLog ${APACHE_LOG_DIR}/site-error.log
    CustomLog ${APACHE_LOG_DIR}/site-access.log combined
</VirtualHost>
```

Ative e recarregue:

```bash
sudo a2ensite site.conf
sudo apache2ctl configtest
sudo systemctl reload apache2
```

Teste:

```bash
curl -H "Host: site.local" http://127.0.0.1
```

## Módulos

Apache é modular. Você ativa recursos conforme precisa.

| Módulo | Uso comum |
| --- | --- |
| `rewrite` | reescrita de URLs, muito usado por frameworks |
| `proxy` | base para proxy reverso |
| `proxy_http` | proxy reverso HTTP |
| `ssl` | HTTPS |
| `headers` | manipulação de headers |

Ativar módulos:

```bash
sudo a2enmod rewrite
sudo a2enmod proxy
sudo a2enmod proxy_http
sudo a2enmod headers
sudo systemctl restart apache2
```

Listar módulos ativos:

```bash
apache2ctl -M
```

## Proxy reverso com Apache

Backend local na porta `3000`:

```apache
<VirtualHost *:80>
    ServerName api.local

    ProxyPreserveHost On
    ProxyPass / http://127.0.0.1:3000/
    ProxyPassReverse / http://127.0.0.1:3000/

    ErrorLog ${APACHE_LOG_DIR}/api-error.log
    CustomLog ${APACHE_LOG_DIR}/api-access.log combined
</VirtualHost>
```

Ative os módulos necessários:

```bash
sudo a2enmod proxy proxy_http
sudo apache2ctl configtest
sudo systemctl reload apache2
```

## `.htaccess`

O `.htaccess` permite regras por diretório, mas tem custo de performance porque o Apache precisa procurar e interpretar esse arquivo durante a requisição.

Exemplo de permissão para `.htaccess`:

```apache
<Directory /var/www/site>
    AllowOverride All
    Require all granted
</Directory>
```

Exemplo de rewrite:

```apache
RewriteEngine On
RewriteRule ^status$ /health.html [L]
```

## Troubleshooting

```bash
sudo apache2ctl configtest
sudo systemctl status apache2
sudo journalctl -u apache2 -n 100
sudo tail -f /var/log/apache2/error.log
curl -I http://localhost
```

## Mini-desafio

1. Crie um virtual host `site.local`.
2. Sirva um `index.html` a partir de `/var/www/site`.
3. Ative o módulo `rewrite`.
4. Crie uma regra simples de rewrite.
5. Crie outro virtual host `api.local` fazendo proxy para uma aplicação na porta `3000`.
