# 🌾 TerraNova API - DevOps Tools & Cloud Computing

## 🚀 Descrição da Solução Proposta

O **TerraNova** é uma solução tecnológica voltada para a gestão do agronegócio, permitindo o cadastro e monitoramento estruturado de **Produtores**, **Propriedades**, **Talhões** e **Tipos de Plantação**.

Esta entrega contempla a modernização da infraestrutura da API (desenvolvida em **.NET 8**) através da conteinerização com **Docker**. O ambiente foi projetado para rodar de forma isolada na nuvem, contendo dois serviços principais integrados em uma mesma rede virtual (**Bridge**):

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
| Linguagem/Framework         | C# / .NET 8 (ASP.NET Core)                                      |
| Banco de Dados              | Oracle Database 19c                                             |
| Porta Exposta da API        | 8080                                                            |
| Diretório de Trabalho (App) | `/terranova-app`                                                |
| Usuário de Execução (App)   | `app` (Não-root)                                                |
| Variáveis de Ambiente       | `ASPNETCORE_ENVIRONMENT` e `ConnectionStrings__TerraNovaOracle` |

---

# 🚀 Como Executar o Projeto (How To)

Siga as instruções abaixo para realizar o deploy da aplicação e do banco de dados na sua máquina ou em uma instância de nuvem.

## 1️⃣ Clonar o Repositório

Abra o terminal e execute o comando abaixo para baixar o projeto diretamente da organização da Global Solution:

```bash
git clone https://github.com/Global-Solution-Space/DevOps-Tools-Cloud-Computing.git
cd DevOps-Tools-Cloud-Computing
```

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
# Substitua o RM pelo número correto do representante
docker container exec -it app-rm[INSERIR_RM_AQUI] /bin/bash

# Comprovação do usuário não privilegiado (deve retornar 'app')
whoami

# Comprovação do diretório de trabalho (deve retornar '/terranova-app')
pwd

# Listar os arquivos compilados da aplicação
ls -la

# Sair do container
exit
```

## 📌 Validação do Banco de Dados e Persistência (Oracle)

Acesse o terminal do container do banco de dados para validar o relacionamento do CRUD de gestão agrícola:

```bash
# Substitua o RM pelo número correto do representante
docker container exec -it db-rm[INSERIR_RM_AQUI] bash

# Acesse o SQL*Plus do Oracle
# (substitua pelas credenciais configuradas no docker-compose)
sqlplus system/SuaSenhaOracle@//localhost:1521/XEPDB1

# Execute consultas para comprovar o relacionamento do domínio agrícola
SELECT * FROM PRODUTOR;
SELECT * FROM PROPRIEDADE;
SELECT * FROM TALHAO;
```

---

# 🎥 Entregáveis

## 📂 Repositório GitHub

https://github.com/Global-Solution-Space/DevOps-Tools-Cloud-Computing

## 🎬 Vídeo Demonstrativo (YouTube)

> [COLOQUE O LINK DO VÍDEO AQUI]

---

# 👥 Integrantes da Equipe

| Nome | RM |
|------|------|
| Enzo Okuizumi Miranda de Souza | 561432 |
| Gustavo Keiji Okada | 563428 |
| Lucas Barros Gouveia | 566422 |
| Luna de Carvalho Guimarães | 562290 |
| Milton Jakson de Sousa Marcelino | 564836 |