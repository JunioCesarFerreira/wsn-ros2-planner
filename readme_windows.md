# 🧭 Action Planner

Este projeto utiliza **ROS 2** e **PDDL** para planejamento de ações.
O container Docker fornece um ambiente pronto para executar o sistema e desenvolver novos *action nodes*.

---

## ⚙️ Pré-requisitos

* [Docker](https://www.docker.com/)
* [Python 3](https://www.python.org/) (somente no Windows para o script de normalização de finais de linha)
* Sistema operacional compatível (Linux, macOS ou Windows)

---

## 🧹 Normalizar finais de linha (Windows)

Se estiver no **Windows**, é necessário normalizar os arquivos para usar **LF** (line feed) antes de buildar o container:

```bash
py tools/CRLF_to_LF.py .
```

> 💡 É necessário ter o Python instalado.

---

## 🐋 Build do Container

Execute o comando abaixo para construir a imagem Docker:

```bash
docker build -t action_planner .
```

---

## 🚀 Executando o Container

Monte o diretório `pddl` dentro do container:

```bash
docker run -it -v ./pddl:/pddl action_planner
```

> 🪟 **No Windows**, use `.\` em vez de `./`:
>
> ```bash
> docker run -it -v .\pddl:/pddl action_planner
> ```

---

## ▶️ Iniciar o Sistema

Dentro do container, inicie o sistema com:

```bash
ros2 launch launch/launch.py
```

---

## 🧩 Criando Novos *Action Nodes* ou Modificando Domain/Problem

1. **Crie um novo *action node***
   Adicione o novo script Python em `scripts/`.
   No construtor da classe, atualize o nome da ação:

   ```python
   def __init__(self):
       super().__init__("pegar")  # altere "pegar" para o nome da sua ação
   ```

2. **Atualize os argumentos na função `new_goal`**
   Os parâmetros devem corresponder aos argumentos definidos no arquivo **domain.pddl**.

3. **Registre o novo nó no `CMakeLists.txt`**

   ```cmake
   install(PROGRAMS
     # nós existentes
     scripts/pegar.py  # altere para o nome do seu script
     DESTINATION lib/${PROJECT_NAME})
   ```

4. **Adicione o nó à variável `nodes` em `lifecycle_manager.py`**

   ```python
   nodes = [
       {
           'node_name': 'pegar',
           'depends_on': []
       },
       # demais nós...
   ]
   ```

---

## 📂 Estrutura Básica do Projeto

```
action_planner/
├── Dockerfile
├── launch/
│   └── launch.py
├── scripts/
│   ├── pegar.py
│   └── outros_nos.py
├── pddl/
│   ├── domain.pddl
│   └── problem.pddl
├── tools
│   ├── add_action_node.py
│   └── CRLF_to_LF.py
```

--- 

## 🛠️ Tools
- `CRLF_to_LF.py`: Apenas para normalização do LF no Windows antes de realizar a construção da imagem Docker.
- `add_action_node.py`: Automação para inclusão de novos nodes de ação. Ainda precisa ser revisada e melhorada.
>Exemplos de uso:
```bash
# Exemplo: cria o node "pegar" com a classe "PegarAction"
python tools/add_action_node.py --name pegar --class PegarAction

# Com dependências (vírgula separada)
python tools/add_action_node.py --name entregar --class EntregarAction --depends "pegar,outro_no"

# Simular sem escrever nada
python tools/add_action_node.py --name inspecionar --dry-run
```

---
