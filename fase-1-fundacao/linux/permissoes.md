Dicas pessoais
Sempre validar comando destrutivo antes (rm -rf)
Preferir ss ao invés de netstat
history para revisar comandos
clear limpa terminal
CTRL + R busca histórico


# linux/permissoes.md

# Permissões Linux — Guia Prático

## Conceito básico

Cada arquivo/diretório possui:

- Dono (User)
- Grupo (Group)
- Outros (Others)

Formato:

```bash
-rwxr-xr--
Significado:
-   -> tipo (arquivo)
d   -> diretório
r   -> leitura
w   -> escrita
x   -> execução
Exemplo
-rwxr-xr--
Quebra:
rwx -> dono
r-x -> grupo
r-- -> outros
Ver permissões
ls -l
Alterar permissões com chmod
Forma numérica:
chmod 755 script.sh
Entendendo:
7 = rwx = 4+2+1
5 = r-x = 4+0+1
4 = r--
Exemplos:
chmod 777 arquivo      # Tudo para todos
chmod 755 script.sh    # Executável comum
chmod 644 arquivo.txt  # Arquivo comum
chmod +x script.sh     # Adiciona execução
chmod -w arquivo.txt   # Remove escrita
Alterar dono
sudo chown usuario arquivo
sudo chown usuario:grupo arquivo
Exemplo:
sudo chown paulo:paulo script.sh
Alterar grupo
sudo chgrp grupo arquivo
Diretórios

Para entrar em diretório precisa x.

chmod 755 pasta
Permissões especiais
SUID
chmod u+s arquivo
SGID
chmod g+s pasta
Sticky Bit
chmod +t pasta

Exemplo clássico:

/tmp
Segurança
Nunca usar sem necessidade:
chmod -R 777 /
Boa prática:
644 para arquivos
755 para scripts
700 para .ssh
SSH
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
chmod 600 ~/.ssh/id_ed25519
Resumo rápido
755 = rwxr-xr-x
744 = rwxr--r--
700 = rwx------
644 = rw-r--r--
600 = rw-------
Dica prática

Pense assim:

r = ver
w = alterar
x = executar/entrar

Exemplo:
Sem x numa pasta = você vê nome, mas não entra.