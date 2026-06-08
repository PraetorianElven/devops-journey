from flask import Flask

# inicializando a aplicação Flask
app = Flask(__name__)

# Define a rota para a página inicial
@app.route('/')
def hello_world():
    return 'Hello, World!'


# Rodando a aplicação Flask

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)


# 0.0.0.0 escuta em todas as interfaces de rede, permitindo que a aplicação seja acessível de fora do contêiner.
# A porta 5000 é a porta padrão para aplicações Flask, mas pode ser alterada conforme necessário.
#  O parâmetro debug=True ativa o modo de depuração, que é útil durante o