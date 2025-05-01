# **Sistema de Controle Bélico**

Este sistema foi desenvolvido como parte de um desafio de seleção e visa gerenciar o controle de movimentações de armas, guardas, unidades, equipes e afins. O sistema foi construído utilizando **Ruby 3.2.2** e **Rails 7.1.2**.

## **Pré-requisitos**

Antes de rodar o projeto, é necessário ter alguns pré-requisitos instalados na sua máquina:

- **Ruby 3.2.2**
- **Rails 7.1.2**
- **PostgreSQL**
- **Bundler** (para gerenciar dependências)

## **Instalação e Execução**

### 1. **Clone o repositório**

Primeiro, clone o repositório do projeto para sua máquina local:

```bash
git clone <https://github.com/tallyson-izidio/controle_belico_gcm.git>
cd <controle_belico_gcm>
```

### 2. Instale o Ruby

Se você não tem o Ruby 3.2.2 instalado, você pode usar o `rbenv` ou `rvm` para gerenciar versões do Ruby.

#### Para instalar o Ruby 3.2.2 usando o `rbenv`:

```bash
rbenv install 3.2.2
rbenv global 3.2.2
```
Verifique se a instalação foi bem-sucedida:
```bash
ruby -v
```
### 3. Instale o Rails
```bash
gem install rails -v 7.1.2
```
### 4. Instale as dependências do projeto
```bash
bundle install
```
### 5. Configure o banco de dados
```bash
rails db:create
rails db:migrate
rails db:seed  # Caso tenha seeders para popular o banco de dados
```
### 6. Suba o servidor
```bash
rails server
ou rails s
```
O servidor estará rodando no endereço: http://localhost:3000.

