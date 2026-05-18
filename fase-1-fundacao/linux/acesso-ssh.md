# Acesso SSH por chave sem senha

## Objetivo

Configurar acesso SSH com chave publica/privada e desativar login por senha no servidor.

## 1. Gerar a chave SSH na maquina cliente

```bash
ssh-keygen -t ed25519 -C "meu-acesso-ssh"
```

Arquivos gerados por padrao:

- `~/.ssh/id_ed25519`
- `~/.ssh/id_ed25519.pub`

## 2. Copiar a chave publica para o servidor

```bash
ssh-copy-id usuario@ip-do-servidor
```

Exemplo:

```bash
ssh-copy-id paulo@192.168.31.100
```

## 3. Testar acesso por chave

```bash
ssh usuario@ip-do-servidor
```

Se o login ocorrer sem pedir a senha do usuario remoto, o acesso por chave funcionou.

## 4. Validar `authorized_keys` e permissoes

```bash
ls -la ~/.ssh
cat ~/.ssh/authorized_keys
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
```

## 5. Desativar login por senha no SSH

Editar `/etc/ssh/sshd_config` e garantir estas diretivas:

```text
PasswordAuthentication no
PubkeyAuthentication yes
PermitRootLogin no
```

## 6. Validar a configuracao

```bash
sudo sshd -t
```

## 7. Reiniciar o servico SSH

Debian/Ubuntu:

```bash
sudo systemctl restart ssh
```

Outras distribuicoes:

```bash
sudo systemctl restart sshd
```

## 8. Teste final

Abrir outro terminal e testar novamente:

```bash
ssh usuario@ip-do-servidor
```

Manter a sessao antiga aberta ate confirmar que o novo acesso funciona.

## 9. Confirmar que senha foi bloqueada

```bash
ssh -o PubkeyAuthentication=no usuario@ip-do-servidor
```

Resultado esperado:

```text
Permission denied
```

## Checklist de validacao

- chave criada com `ssh-keygen`
- chave publica copiada com `ssh-copy-id`
- login por chave funcionando
- `PasswordAuthentication no` aplicado
- configuracao validada com `sshd -t`
- servico reiniciado sem erro
