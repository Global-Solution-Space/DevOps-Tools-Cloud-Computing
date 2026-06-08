# 🌾 TerraNova API - DevOps Tools & Cloud Computing


# 👥 Integrantes da Equipe

| Nome | RM |
|------|------|
| Enzo Okuizumi Miranda de Souza | 561432 |
| Gustavo Keiji Okada | 563428 |
| Lucas Barros Gouveia | 566422 |
| Luna de Carvalho Guimarães | 562290 |
| Milton Jakson de Sousa Marcelino | 564836 |

## 📂 Repositório GitHub

[Repositório GitHub](https://github.com/Global-Solution-Space/DevOps-Tools-Cloud-Computing) | [Vídeo Demonstrativo]() 

## 🚀 Descrição da Solução Proposta

O **TerraNova** é uma solução tecnológica voltada para a gestão do agronegócio, permitindo o cadastro e monitoramento estruturado de **Produtores**, **Propriedades**, **Talhões** e **Tipos de Plantação**.

Esta entrega contempla a modernização da infraestrutura da API (desenvolvida em **.NET 10**) através da conteinerização com **Docker**. O ambiente foi projetado para rodar de forma isolada na nuvem, contendo dois serviços principais integrados em uma mesma rede virtual (**Bridge**):

### 📦 Container da Aplicação (App)

Executa a API do TerraNova utilizando diretrizes de segurança, operando com usuário não privilegiado e em um diretório de trabalho customizado (`/terranova-app`).

### 🗄️ Container do Banco de Dados (DB)

Executa o Oracle Database, persistindo as informações de todo o ecossistema agrícola em um volume nomeado, garantindo a integridade dos dados independente do ciclo de vida do container.

---

## 🏗️ Desenho Macro da Arquitetura

Abaixo está a representação da arquitetura macro da solução na nuvem, detalhando a comunicação entre os containers, exposição de portas, volumes e o fluxo de requisições.

> ⚠️ **[COLOQUE AQUI O LINK DA IMAGEM DO SEU DIAGRAMA DRAW.IO ATUALIZADO]**

---

## 🛠️ Tecnologias e Configurações dos Containers

| Configuração                | Valor                                                           |
| --------------------------- | --------------------------------------------------------------- |
| Linguagem/Framework         | C# / .NET 10 (ASP.NET Core)                                     |
| Banco de Dados              | Oracle Database XE 21c (`gvenzl/oracle-xe:21-slim`)             |
| Porta Exposta da API        | 8080                                                            |
| Diretório de Trabalho (App) | `/terranova-app`                                                |
| Usuário de Execução (App)   | `app` (Não-root)                                                |
| Container da API            | `terranova-api-rm561432`                                                 |
| Container do Banco          | `oracle-db-rm561432`                                                     |
| Variáveis de Ambiente       | `ASPNETCORE_ENVIRONMENT`, `ConnectionStrings__TerraNovaOracle` e `SatVegApiToken` |

---

# 🚀 Como Executar o Projeto (How To)

Siga as instruções abaixo para realizar o deploy da aplicação e do banco de dados na sua máquina ou em uma instância de nuvem.

## 1️⃣ Clonar o Repositório

Abra o terminal e execute o comando abaixo para baixar o projeto diretamente da organização da Global Solution:

```bash
git clone https://github.com/Global-Solution-Space/DevOps-Tools-Cloud-Computing.git
cd DevOps-Tools-Cloud-Computing
cd TerraNova
```

> ℹ️ O `docker-compose.yml` está versionado dentro da pasta `TerraNova/`, por isso entramos nela antes de executar os comandos do Docker.

## 2️⃣ Executar a Solução em Segundo Plano (Background)

Para construir a imagem da API .NET e subir o banco de dados Oracle simultaneamente na mesma rede, execute:

```bash
docker compose up -d --build
```

## 3️⃣ Exibir os Logs dos Containers

Para garantir que a API iniciou corretamente e o Oracle finalizou o setup inicial, visualize os logs:

```bash
docker compose logs -f
```

---

# 🔍 Evidências de Execução (Validação)

Conforme os requisitos do projeto, abaixo estão os comandos para validar a estrutura interna dos containers e a persistência de dados.

## 📌 Validação do Container da Aplicação (.NET)

Acesse o terminal interativo do container da API para comprovar o usuário e o diretório de trabalho configurados no Dockerfile:

```bash
# Acessa o container da API (nome definido no docker-compose: terranova-api)
docker container exec -it terranova-api /bin/bash

# Comprovação do usuário não privilegiado (deve retornar 'app')
whoami

# Comprovação do diretório de trabalho (deve retornar '/terranova-app')
pwd

# Listar os arquivos compilados da aplicação
ls -la

# Sair do container
exit
```

---

# 🧪 Comandos CRUD

Abaixo estão os comandos `curl` para exercitar a API após o `docker compose up -d --build` estar rodando. A API expõe os endpoints no prefixo `api/` e a interface interativa do Swagger está disponível em `http://localhost:8080/swagger`.

> 🔁 **Ordem recomendada**: como as entidades possuem chaves estrangeiras entre si, cadastre primeiro o que não depende de ninguém e vá avançando. Use o `id` retornado em cada resposta como variável nos passos seguintes.

> 🌍 Substitua `localhost:8080` pelo IP público da VM (`$PUBLIC_IP:8080`) caso esteja executando no Azure.

## 1️⃣ Criar um Tipo de Plantação (sem dependências)

```bash
# CREATE
curl -X POST http://localhost:8080/api/tipoplantacao \
  -H "Content-Type: application/json" \
  -d '{
    "tipoPlant": "Soja"
  }'
# → retorna 201 Created com o JSON do recurso e o campo "id"

# READ ALL
curl http://localhost:8080/api/tipoplantacao

# READ BY ID
curl http://localhost:8080/api/tipoplantacao/<id>

# UPDATE
curl -X PUT http://localhost:8080/api/tipoplantacao/<id> \
  -H "Content-Type: application/json" \
  -d '{
    "tipoPlant": "Soja Transgênica"
  }'

# DELETE
curl -X DELETE http://localhost:8080/api/tipoplantacao/<id>
```

## 2️⃣ Criar uma Localização (sem dependências)

```bash
# CREATE
curl -X POST http://localhost:8080/api/localizacao \
  -H "Content-Type: application/json" \
  -d '{
    "latitude":  -23.5505,
    "longitude": -46.6333
  }'
# → guarda o "id" retornado (será usado em Propriedade e Talhão)

# READ ALL
curl http://localhost:8080/api/localizacao

# READ BY ID
curl http://localhost:8080/api/localizacao/<id>

# UPDATE
curl -X PUT http://localhost:8080/api/localizacao/<id> \
  -H "Content-Type: application/json" \
  -d '{
    "latitude":  -22.9068,
    "longitude": -43.1729
  }'

# DELETE
curl -X DELETE http://localhost:8080/api/localizacao/<id>
```

## 3️⃣ Criar um Produtor (depende apenas de si mesmo; já cadastra o telefone)

```bash
# CREATE (cadastra produtor + telefone na mesma chamada)
curl -X POST http://localhost:8080/api/produtor \
  -H "Content-Type: application/json" \
  -d '{
    "nome":   "João da Silva",
    "email":  "joao.silva@terranova.com",
    "senha":  "senha123",
    "telefoneContato": "11987654321"
  }'
# → guarda o "id" retornado (será usado em Propriedade)

# READ ALL
curl http://localhost:8080/api/produtor

# READ BY ID
curl http://localhost:8080/api/produtor/<id>

# READ BY EMAIL
curl "http://localhost:8080/api/produtor/by-email?email=joao.silva@terranova.com"

# UPDATE
curl -X PUT http://localhost:8080/api/produtor/<id> \
  -H "Content-Type: application/json" \
  -d '{
    "nome":   "João da Silva Jr.",
    "email":  "joao.jr@terranova.com",
    "senha":  "novaSenha123",
    "telefoneContato": "11999998888"
  }'

# DELETE
curl -X DELETE http://localhost:8080/api/produtor/<id>
```

## 4️⃣ Criar uma Propriedade (depende de um Produtor + uma Localização)

```bash
# CREATE
curl -X POST http://localhost:8080/api/propriedade \
  -H "Content-Type: application/json" \
  -d '{
    "nome":         "Fazenda Boa Vista",
    "tamanhoTotal": 150.75,
    "produtorId":   "<produtor-id>",
    "localizacaoId":"<localizacao-id>"
  }'
# → guarda o "id" retornado (será usado em Talhão)

# READ ALL
curl http://localhost:8080/api/propriedade

# READ BY ID
curl http://localhost:8080/api/propriedade/<id>

# READ BY PRODUTOR
curl http://localhost:8080/api/propriedade/by-produtor/<produtor-id>

# UPDATE
curl -X PUT http://localhost:8080/api/propriedade/<id> \
  -H "Content-Type: application/json" \
  -d '{
    "nome":         "Fazenda Boa Vista - Sede",
    "tamanhoTotal": 175.00,
    "produtorId":   "<produtor-id>",
    "localizacaoId":"<localizacao-id>"
  }'

# DELETE
curl -X DELETE http://localhost:8080/api/propriedade/<id>
```

## 5️⃣ Criar um Talhão (depende de TipoPlantação + Propriedade + Localização)

```bash
# CREATE
curl -X POST http://localhost:8080/api/talhao \
  -H "Content-Type: application/json" \
  -d '{
    "nomeTalhao":       "Talhão 01 - Soja",
    "volumArea":        45.50,
    "tipoPlantacaoId":  "<tipo-plantacao-id>",
    "propriedadeId":    "<propriedade-id>",
    "localizacaoId":    "<localizacao-id>"
  }'

# READ ALL
curl http://localhost:8080/api/talhao

# READ BY ID
curl http://localhost:8080/api/talhao/<id>

# READ BY PROPRIEDADE
curl http://localhost:8080/api/talhao/by-propriedade/<propriedade-id>

# READ BY TIPO PLANTACAO
curl http://localhost:8080/api/talhao/by-tipo-plantacao/<tipo-plantacao-id>

# UPDATE
curl -X PUT http://localhost:8080/api/talhao/<id> \
  -H "Content-Type: application/json" \
  -d '{
    "nomeTalhao":       "Talhão 01 - Soja (Renomeado)",
    "volumArea":        50.00,
    "tipoPlantacaoId":  "<tipo-plantacao-id>",
    "propriedadeId":    "<propriedade-id>",
    "localizacaoId":    "<localizacao-id>"
  }'

# DELETE
curl -X DELETE http://localhost:8080/api/talhao/<id>
```

## 📋 Tabela Resumo de Endpoints

## Tabela tipo_plantacao

| Verbo     | Rota                                              | Descrição                              |
| --------- | ------------------------------------------------- | -------------------------------------- |
| `GET`     | `/api/tipoplantacao`                              | Lista todos os tipos de plantação      |
| `GET`     | `/api/tipoplantacao/{id}`                         | Busca tipo de plantação por ID         |
| `POST`    | `/api/tipoplantacao`                              | Cria um tipo de plantação              |
| `PUT`     | `/api/tipoplantacao/{id}`                         | Atualiza um tipo de plantação          |
| `DELETE`  | `/api/tipoplantacao/{id}`                         | Remove um tipo de plantação            |

## Tabela localizacao

| Verbo     | Rota                                              | Descrição                              |
| --------- | ------------------------------------------------- | -------------------------------------- |
| `GET`     | `/api/localizacao`                                | Lista todas as localizações            |
| `GET`     | `/api/localizacao/{id}`                           | Busca localização por ID               |
| `POST`    | `/api/localizacao`                                | Cria uma localização                   |
| `PUT`     | `/api/localizacao/{id}`                           | Atualiza uma localização               |
| `DELETE`  | `/api/localizacao/{id}`                           | Remove uma localização                 |

## Tabela produtor

| Verbo     | Rota                                              | Descrição                              |
| --------- | ------------------------------------------------- | -------------------------------------- |
| `GET`     | `/api/produtor`                                   | Lista todos os produtores              |
| `GET`     | `/api/produtor/{id}`                              | Busca produtor por ID                  |
| `GET`     | `/api/produtor/by-email?email={email}`            | Busca produtor por e-mail              |
| `POST`    | `/api/produtor`                                   | Cria um produtor (com telefone)        |
| `PUT`     | `/api/produtor/{id}`                              | Atualiza um produtor                   |
| `DELETE`  | `/api/produtor/{id}`                              | Remove um produtor                     |

## Tabela propriedade

| Verbo     | Rota                                              | Descrição                              |
| --------- | ------------------------------------------------- | -------------------------------------- |
| `GET`     | `/api/propriedade`                                | Lista todas as propriedades            |
| `GET`     | `/api/propriedade/{id}`                           | Busca propriedade por ID               |
| `GET`     | `/api/propriedade/by-produtor/{produtorId}`       | Lista propriedades de um produtor      |
| `POST`    | `/api/propriedade`                                | Cria uma propriedade                   |
| `PUT`     | `/api/propriedade/{id}`                           | Atualiza uma propriedade               |
| `DELETE`  | `/api/propriedade/{id}`                           | Remove uma propriedade                 |

## Tabela talhao

| Verbo     | Rota                                              | Descrição                              |
| --------- | ------------------------------------------------- | -------------------------------------- |
| `GET`     | `/api/talhao`                                     | Lista todos os talhões                 |
| `GET`     | `/api/talhao/{id}`                                | Busca talhão por ID                    |
| `GET`     | `/api/talhao/by-propriedade/{propriedadeId}`      | Lista talhões de uma propriedade       |
| `GET`     | `/api/talhao/by-tipo-plantacao/{tipoPlantacaoId}` | Lista talhões de um tipo de plantação  |
| `POST`    | `/api/talhao`                                     | Cria um talhão                         |
| `PUT`     | `/api/talhao/{id}`                                | Atualiza um talhão                     |
| `DELETE`  | `/api/talhao/{id}`                                | Remove um talhão                       |

> 💡 **Dica**: você também pode usar a interface gráfica do Swagger em `http://localhost:8080/swagger` para testar todas as rotas com formulários automáticos.

---

## 📌 Validação do Banco de Dados e Persistência (Oracle)

Acesse o terminal do container do banco de dados para validar o relacionamento do CRUD de gestão agrícola:

```bash
# Acessa o container do banco (nome definido no docker-compose: oracle-db)
docker container exec -it oracle-db bash

# Acesse o SQL*Plus do Oracle
# (credenciais configuradas no docker-compose: terranova_user / terranova123)
sqlplus terranova_user/terranova123@//localhost:1521/XEPDB1

# Execute consultas para comprovar o relacionamento do domínio agrícola
SELECT * FROM PRODUTOR;
SELECT * FROM PROPRIEDADE;
SELECT * FROM TALHAO;
```