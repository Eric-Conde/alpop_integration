## Foco da iniciativa

a. Capacitar a equipe Alpop em engenharia de software profissional. 

b. Para alcançar (a), escolha e desenho de um problema real da empresa, para ser tratado exclusivamente com Ruby.

c. Criar tecnologia baseada em APIs, para suportar uma estratégia de dados e analytics.

d. Integrar os dados das ferramentas utilizadas na operação do Alpop: Zendesk, Pipefy, Superlógica, Google Sheets.

e. Incremento da eficiência operacional Alpop.

f. Projeto de software livre que poderá ser adotado por outros participantes do mercado.

## Contexto

A partir de nov/2019 foi iniciado no Alpop um programa de reorganização das áreas, processos e instrumentação. A implementação desse programa foi realizada com base na utilização de variadas tecnologias e plataformas. Apesar dos ganhos operacionais, houve a fragmentação das informações. Essa fragmentação dificulta o processo de coleta e organização dos dados, não permitindo uma operação e gestão orientada por dados e em tempo real.

## O problema em mãos

O Alpop utiliza as seguintes ferramentas:

- **Plataforma Alpop**: responsável pelo gerenciamento do estoque de imóveis e pela originação de interesses. Os interesses iniciam o processo "Atendimento" do Alpop.

- **Pipefy**: todos os processos do Alpop são implementados no Pipefy. Essa ferramenta permite organizar o dia de trabalho de cada uma das áreas, além de registrar a performance para cada procedimento específico. Esses registros são feitos enquanto a pessoa trabalha no dia-a-dia, evitando perda de tempo criando e organizando dados sobre o processo.

- **Zendesk**: sistema de gestão de tickets do Alpop. É a plataforma que unifica todos os canais do Alpop (omnichannel) e a interação com os clientes. Os tickets criados no Zendesk são automaticamente criados no Pipefy para startar os procedimentos nas respectivas áreas.

- **Superlógica**: sistema de gestão para imobiliárias. Apoia na organização dos contratos, inquilinos, proprietários, cobranças, entre outros. É esse sistema que concentra as informações de planejamento, financeiras, administrativas.

- **Google sheets**: sistema de planilhas, utilizado para organizar visões específicas dos nossos dados.

Todas essas ferramentas geram dados específicos sobre o Alpop que são fundamentais para a operação e gestão do negócio. Com ciclos cada vez mais curtos de tomada de decisão, é preciso que a organização de visões sobre os dados aconteça em tempo real.

Para alcançar esse objetivo, é preciso criar mecanismos para coletar dados nesses sistemas, de modo a subsidiar a criação de novas visualizações e agregações para suportar processos analíticos e decisórios. Todos esses sistemas possuem interfaces para que outros sistemas pluguem e recuperem dados. Essas interfaces são chamada de API (Application Programming Interface).

## Arquitetura

Pra endereçar o problema mencionado, os seguintes conceitos foram trabalhados:

**a. Objetos de domínio Ruby:** para cada integração com plataformas de terceiros, vamos criar classes Ruby que representam os conceitos das APIs. Exemplo: se o Superlógica trabalha com o conceito "Cobranças" teremos uma classe Ruby chamada "Cobranca". Essa classe terá métodos específicos de acesso aos dados da integração.

**b. APIs de terceiros:** são as APIs das diversas ferramentas que são empregadas no Alpop. Elas possuem interfaces, modos de acesso, autenticação e dados específicos.

**c. Middleware:** componente responsável por realizar a ponte entre os **Objetos de domínio Ruby** e as **APIs de terceiros**. Responsável por credenciais de acesso, segurança, requisições às APIs.

**d. Query builder:** componente responsável por gerenciar a construção das consultas que serão feitas nas APIs.

**e. Parser:** componente responsável por processar as respostas das APIs. Em outras palavras: processam os dados de retorno e criam os objetos Ruby.

Portanto, para implementar uma nova integração, o passo-a-passo é:

1. Criar/Incrementar o objeto de domínio Ruby. Em outras palavras: se você quer recuperar todos os contratos ativos do Superlógica, você deve começar pelos testes da Classe Superlógica::Contrato. Comece sempre pelos testes.
2. Ao seguir o processo de TDD, vários erros vão aparecendo, relacionados com os outros componentes da arquitetura.
3. Configurar o provedor dos dados no arquivo catalog.yml.
4. Configurar a consulta no arquivo queries.yml. Exemplo: se você deseja recuperar todos os cards de uma etapa do processo no Pipefy, você deverá especificar qual é consulta para obtenção desses dados.
5. Implementar os métodos no Parser, para o processamento dos retornos e criação dos objetos Ruby.

Nesse processo é muito importante conhecer os dados de retorno. Para isso, utilize ferramentas como o seu navegador ou então o Curl para simular uma requisição e obter amostras dos dados de retorno. Conhecer os dados de retorno é fundamental para a etapa (5), mas também para todo o processo de TDD.



























