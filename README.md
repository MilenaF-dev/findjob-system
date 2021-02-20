# FindJobs

## Descrição do Projeto
<p align="justify"> Projeto final do TreinaDev, que consiste na criação de uma plataforma Web que auxilia pessoas do departamento de RH de empresas no processo de contratação. Através dessa plataforma, os funcionários poderão criar vagas, receber e analisar candidaturas e enviar propostas aos candidatos, tudo de forma colaborativa. Além disso, a plataforma funciona como um site de busca de oportunidades para os visitantes. Os visitantes podem visitar os perfis das empresas, ver suas vagas disponíveis e se candidatar para estas vagas.</p>

> Status do Projeto: Em desenvolvimento :warning:

> Link do planejamento no trello [aqui](https://trello.com/b/sMTMq9y2/findjob-system)

### Funcionalidades básicas
- [X] Colaborador cria uma conta usando e-mail da empresa;
- [X] Colaborador preenche dados da empresa, caso seja a primeira pessoa da empresa a se cadastrar;
- [X] Colaborador cadastra uma nova vaga de emprego;
- [X] Visitante navega pelo site e vê as empresas cadastradas;
- [X] Visitante decide se inscrever para uma vaga;
- [X] Visitante cria sua conta e preenche um perfil para confirmar sua candidatura;
- [ ] Colaborador da empresa visualiza as candidaturas recebidas;
- [ ] Colaborador da empresa faz uma proposta para um candidato;
- [ ] Candidato (agora autenticado) visualiza as propostas recebidas;
- [ ] Colaborador ou candidato podem aceitar/reprovar uma candidatura.
- [ ] Visitante realiza buscas de empresas e/ou vagas;

#### Como rodar a aplicação :arrow_forward: 
<p align="justify">Para executar esse projeto você deve ter instalado em seu computador, preferencialmente com algum sistema operacionais Unix, a linguagem de programação Ruby na versão 2.7.1 e Rails na versão 6.1.2. Além disso, você vai precisar ter instalado outros pré-requisitos, como: </p>

* [Git](https://git-scm.com/book/pt-br/v2/Começando-Instalando-o-Git), [NodeJS](https://nodejs.org/pt-br/download/package-manager/), [Yarn](https://classic.yarnpkg.com/pt-BR/docs/install/)

<p>Após realizar a configuração do seu computador, no terminal, clone o projeto:</p>

> git clone https://github.com/MilenaF-dev/findjob-system

<p>Entre na pasta do projeto:</p>

> cd findjob-system

<p>Execute o seguinte comando:</p>

> $ bundle install

<p>Para gerar o banco de dados execute os comandos:</p>

> $ rails db:create

> $ rails db:migrate

#### Para rodar os testes: 

<p>Execute o seguinte comando no terminal:</p>

> $ rspec

#### Acesso a aplicação pelo navegador:

* Execute no terminal: `$ rails server`
* Abra em seu navegador: `localhost:3000`
* Pronto! Você está na aplicação!

#### Gems utilizadas

* [Devise](https://github.com/heartcombo/devise) para a autenticação do usuário
* [Rspec](https://github.com/rspec/rspec-rails) e [Capybara](https://github.com/teamcapybara/capybara) para testes



