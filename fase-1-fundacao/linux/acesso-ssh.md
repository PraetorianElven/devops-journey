Acesso SSH por chave sem senha
Objetivo
Configurar acesso SSH usando chave pública/privada e desativar login por senha no servidor.

1. Gerar chave SSH na máquina cliente
Na máquina que vai acessar o servidor:
ssh-keygen -t ed25519 -C "meu-acesso-ssh"
Pressione Enter para aceitar o caminho padrão:
~/.ssh/id_ed25519
Arquivos gerados:
~/.ssh/id_ed25519      # chave privada
~/.ssh/id_ed25519.pub  # chave pública
A chave privada nunca deve ser compartilhada.

2. Copiar a chave pública para o servidor
Substitua usuario e ip-do-servidor pelos dados corretos:
ssh-copy-id usuario@ip-do-servidor
Exemplo:
ssh-copy-id paulo@192.168.31.100

3. Testar acesso por chave
ssh usuario@ip-do-servidor
Exemplo:
ssh paulo@192.168.31.100
Se entrou sem pedir senha do usuário, o acesso por chave funcionou.

4. Validar arquivo authorized_keys no servidor
No servidor:
ls -la ~/.ssh
cat ~/.ssh/authorized_keys
Permissões recomendadas:
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys

5. Desativar login por senha no SSH
No servidor, edite o arquivo:
sudo nano /etc/ssh/sshd_config
Procure ou adicione as linhas:
PasswordAuthentication no
PubkeyAuthentication yes
PermitRootLogin no
Explicação:
    • PasswordAuthentication no: bloqueia login por senha\
    • PubkeyAuthentication yes: permite login por chave SSH\
    • PermitRootLogin no: impede login direto como root

6. Validar configuração antes de reiniciar
Antes de reiniciar o SSH, valide se o arquivo está correto:
sudo sshd -t
Se não aparecer erro, a configuração está válida.

7. Reiniciar serviço SSH
Debian/Ubuntu:
sudo systemctl restart ssh
Algumas distribuições:
sudo systemctl restart sshd

8. Teste final
Abra outro terminal e teste novamente:
ssh usuario@ip-do-servidor
Importante: mantenha a sessão SSH antiga aberta até confirmar que o novo acesso funciona.

9. Testar se senha foi bloqueada
Force o SSH a tentar senha:
ssh -o PubkeyAuthentication=no usuario@ip-do-servidor
Resultado esperado:
Permission denied
Isso confirma que login por senha foi desativado.

Resumo
Neste desafio foi configurado:
    • Geração de chave SSH\
    • Cópia da chave pública para o servidor\
    • Login SSH sem senha\
    • Desativação de autenticação por senha\
    • Bloqueio de login direto como root\
    • Validação da configuração do SSH
