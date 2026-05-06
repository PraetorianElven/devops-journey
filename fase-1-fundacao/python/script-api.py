from flask import Flask, jsonify, request
# Importa do Flask:
# Flask   -> cria a aplicação web/API
# jsonify -> transforma dados Python em JSON
# request -> permite ler dados enviados na requisição

app = Flask(__name__)
# Cria a aplicação Flask.
# __name__ indica para o Flask qual é o arquivo principal da aplicação.

tarefas = []
# Lista em memória onde as tarefas serão guardadas.
# Atenção: se a aplicação reiniciar, essa lista é apagada.

@app.route('/')
# Define a rota inicial da API.
# Quando acessar http://localhost:5000/, essa função será executada.

def home():
    # Função executada quando alguém acessa a rota "/".

    return 'Bem-vindo à API de tarefas!'
    # Retorna uma mensagem simples em texto.

@app.route('/tarefas', methods=['GET'])
# Define a rota /tarefas usando o método GET.
# GET é usado para consultar/listar dados.

def listar_tarefas():
    # Função que lista todas as tarefas cadastradas.

    return jsonify(tarefas)
    # Retorna a lista de tarefas no formato JSON.

@app.route('/tarefas', methods=['POST'])
# Define a rota /tarefas usando o método POST.
# POST é usado para criar/enviar novos dados.

def criar_tarefa():
    # Função responsável por criar uma nova tarefa.

    descricao = request.json.get('descricao')
    # Pega o campo "descricao" enviado no corpo da requisição JSON.
    # Exemplo de JSON recebido:
    # { "descricao": "Estudar Flask" }

    nova_tarefa = {'id': len(tarefas) + 1, 'descricao': descricao}
    # Cria um dicionário representando a nova tarefa.
    # O id será o tamanho atual da lista + 1.

    tarefas.append(nova_tarefa)
    # Adiciona a nova tarefa dentro da lista tarefas.

    return jsonify(nova_tarefa), 201
    # Retorna a tarefa criada em JSON.
    # O código HTTP 201 significa "Created", ou seja, criado com sucesso.

# Implemente as rotas para atualizar e excluir tarefas aqui
# Comentário indicando que ainda faltam rotas como:
# PUT/PATCH para atualizar uma tarefa
# DELETE para excluir uma tarefa

if __name__ == '__main__':
    # Verifica se este arquivo está sendo executado diretamente.
    # Se for importado por outro arquivo, o código abaixo não roda.

    app.run(debug=True)
    # Inicia o servidor Flask.
    # debug=True ativa modo de desenvolvimento, mostrando erros detalhados.