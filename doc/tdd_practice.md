## Prática do TDD

**Obs 1.** O passo-a-passo descrito aqui é apenas um exemplo para a prática do TDD. No projeto, a implementação do Card.find(id) já foi refatorada algumas vezes e é diferente do conteúdo abaixo.

### Passo-a-passo para implementar Card.find(id)

Iniciar pelos testes para a classe Pipefy::Card (criar o arquivo card_spec.rb em spec/lib/pipefy/). Em princípio, estamos interessados em recuperar os ID (identificadores únicos) dos cards, bem como o título.

```ruby
# frozen_string_literal: true
require 'pipefy/card'

 describe Pipefy::Card do
   context 'quando Pipefy::Card for inicializado' do
     it 'atribui valor ao id do card' do
       card = build :card
       expect(card.id).not_to be_nil
     end
   end
 end
```

Esse teste indica que existe um atributo id no objeto card, da classe Pipefy::Card, que pode ser preenchido no momento da criação de um objeto. Observe o guard no terminal para ver qual será o primeiro erro.

```bash
 An error occurred while loading ./spec/lib/pipefy/card_spec.rb. - Did you mean?
                  rspec ./spec/lib/pipefy/phase_spec.rb
                    rspec ./spec/lib/pipefy/pipe_spec.rb

 Failure/Error: require 'pipefy/card'

 LoadError:
  cannot load such file -- pipefy/card
  # ./spec/lib/pipefy/card_spec.rb:3:in `require'
```

O erro indica problema no arquivo card_spec.rb, na linha 3. A mensagem de erro informa que não foi possível encontrar o arquivo pipefy/card para fazer o require. Portanto, nosso próximo passo será criar o arquivo pipefy/card.rb.

Após criar o arquivo, rodar os testes novamente. O próximo erro deve ser:

```bash
An error occurred while loading ./spec/lib/pipefy/card_spec.rb.
Failure/Error:
  describe Pipefy::Card do
   context 'quando Pipefy::Card for inicializado' do
     it 'atribui valor ao id do card' do
       card = build :card
      expect(card.id).not_to be_nil
    end
  end
 end

 NameError:
  uninitialized constant Pipefy
 # ./spec/lib/pipefy/card_spec.rb:6:in `<top (required)>'
```

Esse erro indica problema na linha 6 do arquivo card_spec.rb. O erro menciona que não foi possível reconhecer a constante Pipefy, uma vez que ela não existe. Portanto, o próximo passo é criar essa constante no arquivo da classe card.rb.

```ruby
module Pipefy
end
```

Ao salvar o arquivo card.rb, verificar o guard no terminal. O próximo erro segue abaixo:

```bash
An error occurred while loading ./spec/lib/pipefy/card_spec.rb.
Failure/Error:
  describe Pipefy::Card do
   context 'quando Pipefy::Card for inicializado' do
     it 'atribui valor ao id do card' do
       card = build :card
      expect(card.id).not_to be_nil
    end
  end
 end

 NameError:
 uninitialized constant Pipefy::Card
 # ./spec/lib/pipefy/card_spec.rb:6:in `<top (required)>'
```

O próximo erro indica que não foi possível reconhecer a constante Pipefy::Card. Então, para corrigir esse erro basta criar nossa classe Card no módulo Pipefy:

```ruby
module Pipefy
 class Card < Base
 end
end
```

Após isso, verificar o guard. O próximo erro será:

```bash
Failures:

  1) Pipefy::Card initializer when Pipefy::Card is initialized sets the card id
     Failure/Error: card = build :card
     
     NoMethodError:
       undefined method `id=' for #<Pipefy::Card:0x00007fb93c4ddfa8>

  # ./spec/lib/pipefy/card_spec.rb:9:in `block (4 levels) in <top (required)>'
```

O erro está na linha 9 do arquivo de testes. A linha 9 é a que invoca o factory para construção de um objeto Card válido. Essa factory especifica que um atributo id e um atributo title devem ser setados. Quando se tenta criar o objeto com id a partir da factory, chega-se ao erro mencionado: não foi encontrado o método id= que permitira setar o valor do id. Para corrigir esse erro, basta criarmos em nossa classe Card o atributo id e torná-lo acessível. O código abaixo implementa essa definição:

```ruby
1: module Pipefy
2:  class Card < Base
3:    attr_accessor :id 
4:  end
5: end
```

Ao rodar os testes novamente, todos devem passar.

Agora que temos a classe ```Pipefy::Card``` especificada, o próximo passo será implementar um método chamado find, cuja responsabilidade é consultar a API do Pipefy e obter um card específico, fornecendo o id como parâmetro para a consulta. Para implementar os testes dessas funcionalidades, vamos utilizar as funções dos outros componentes da arquitetura, o Middleware, Query Builder e Parsers. Iniciamos pela construção do teste para o método ```find(id)``` da classe ```Pipefy::Card```:

```ruby
1: # frozen_string_literal: true
2:
3: require 'pipefy/card'
5:
6:  describe Pipefy::Card do
7:    context 'quando Pipefy::Card for inicializado' do
8:      it 'atribui valor ao id do card' do
9:        card = build :card
10:       expect(card.id).not_to be_nil
11:     end
12:   end
13:
14:   context 'quando o método find(id) for chamado' do
15:     it 'retorna o card específico pelo id' do
16:       card = Pipefy::Card.find(2122)
17:       expect(card.id).to eq 2122
18:     end
19:   end
20: end
```
O novo teste começa na linha XX. O teste inicia chamando o método find ```Pipefy::Card.find(2122)```, com o parâmetro 2122 (id do card que desejo recuperar). Então, verifica na linha XX se o retorno do método find é um objeto do tipo ```Pipefy::Card``` com o atributo id igual a 2122. Após criar esse teste, verificar o guard. O erro abaixo vai acontecer:

```bash
Failures:

  1) Pipefy::Card quando chamar find(id) retornar o card específico pelo id
     Failure/Error: card = Pipefy::Card.find(2122)
     
     NoMethodError:
       undefined method `find' for Pipefy::Card:Class
     # ./spec/lib/pipefy/card_spec.rb:15:in `block (3 levels) in <top (required)>'

Finished in 0.01184 seconds (files took 1.18 seconds to load)
2 examples, 1 failure

Failed examples:

rspec ./spec/lib/pipefy/card_spec.rb:1
```

O novo erro é ```NoMethodError: card = Pipefy::Card.find(2122)```. Isto porque o método find ainda não foi implementado na classe Pipefy::Card. Então, a próxima implementação é criar um método find na classe Pipefy::Card. O código abaixo representa essa implementação:

```ruby
require 'base'

module Pipefy
  class Card < Base
    attr_accessor :id

    def self.find
    end
  end
end
```

Próximo erro:

```bash
Failures:

  1) Pipefy::Card quando chamar find(id) retornar o card específico pelo id
     Failure/Error:
       def self.find
       end
     
     ArgumentError:
       wrong number of arguments (given 1, expected 0)
     # ./lib/pipefy/card.rb:7:in `find'
     # ./spec/lib/pipefy/card_spec.rb:15:in `block (3 levels) in <top (required)>'
```

Esse erro indica que o método find implementado na classe Pipefy::Card não aceita argumentos. No entanto, o teste está chamando find com o argumento id. Por isso: ```wrong number of arguments (given 1, expected 0)``` aparece no erro. Para corrigir esse erro, basta implementar:

```ruby
require 'base'

module Pipefy
  class Card < Base
    attr_accessor :id

    def self.find(id)
    end
  end
end
```

O que nos leva ao próximo erro:

```bash
Failures:

  1) Pipefy::Card quando chamar find(id) retornar o card específico pelo id
     Failure/Error: expect(card.id).to eq 2122
     
     NoMethodError:
       undefined method `id' for nil:NilClass
     # ./spec/lib/pipefy/card_spec.rb:16:in `block (3 levels) in <top (required)>'
```

O erro ```NoMethodError: undefined method `id' for nil:NilClass``` ocorre porque o método find não tem nenhum implementação, ele foi apenas definido. Com isso, ele retorna ```nil```. A linha ```expect(card.id).to eq 2122``` tenta fazer card.id, mas card é nil e não é possível encontrar um método 'id' para nil:NilClass. Portanto, vamos implementar algo no método find. Lembrando que o objetivo do método find é retornar um objeto da classe Pipefy::Card, portanto, basta inmplementar ```Card.new```. Porém, se prestarmos atenção no nosso teste, ele contém o seguinte: ```expect(card.id).to eq 2122```. Ou seja, esperamos que card tenha um método id e esse método seja igual a 2122. Portanto, podemos implementar diretamente: ```Card.new(2122)```. Um novo erro nos testes então aparece:

```bash
1) Pipefy::Card quando chamar find(id) retornar o card específico pelo id
     Failure/Error: Card.new(2122)
     
     ArgumentError:
       wrong number of arguments (given 1, expected 0)
     # ./lib/pipefy/card.rb:8:in `initialize'
     # ./lib/pipefy/card.rb:8:in `new'
     # ./lib/pipefy/card.rb:8:in `find'
     # ./spec/lib/pipefy/card_spec.rb:15:in `block (3 levels) in <top (required)>'
```

O ```ArgumentError: wrong number of arguments (given 1, expected 0)```está indicando que uma função está sendo chamada com um parâmetro, porém, a implementação espera 0 parâmetros. Que método é esse? Está escrito na linha: ```# ./lib/pipefy/card.rb:8:in `initialize'```. Trata-se do método construtor. Vamos então implementá-lo:

```ruby
require 'base'

module Pipefy
  class Card < Base
    attr_accessor :id

    def initialize(id = nil)
    end

    def self.find(id)
      Card.new(2122)
    end
  end
end
```

Com isso, o erro seguinte será:

```bash
Failures:

  1) Pipefy::Card quando chamar find(id) retornar o card específico pelo id
     Failure/Error: expect(card.id).to eq 2122
     
       expected: 2122
            got: nil
     
       (compared using ==)
     # ./spec/lib/pipefy/card_spec.rb:16:in `block (3 levels) in <top (required)>'
```

Isto é: ao chamad card.id a expectativa é que seja retornado o inteiro 2122. No entanto, o parâmetro id não está sendo salvo na inicialização do objeto. Isso nos leva então a complementar a implementação no método initializer da classe Pipefy::Card:

```ruby
def initialize(id = nil)
  @id = id
end
```

Após essa implementação, todos os testes passam. Porém, ainda não foi alcançado o objetivo. Portanto, nossos testes ainda não representam o problema que queremos tratar. Vamos melhorar nosso teste. Ele agora deve ter a seguinte estrutura:

```ruby
context 'quando chamar find(id)' do
  it 'retornar o card específico pelo id' do
    expected_id = rand(1..5000)
    query = query_builder.build('pipefy', 'card', 'find', {id: expected_id})
    response = middleware.do_request('pipefy', query, 'GET')
    expected_card = Pipefy::Card.parse(response, 'find')

    card = Pipefy::Card.find(expected_id)
    expect(card.id).to eq expected_card.id
  end
end
```

A linha ```expected_id = rand(1..5000)``` serve para gerar um número aleatório para ser utilizado na sequência do teste. Esse número aleatório representa o id que desejamos recuperar. Na sequência, precisamos definir qual a consulta que queremos fazer na API do Pipefy para recuperar um card específico: ```query = query_builder.build('pipefy', 'card', 'find', {id: expected_id})```. Para isso, usamos o método build do QueryBuilder. Uma vez que a query tenha sigo montada, então é hora de pedir ao middleware para fazer uma requisição para a API do Pipefy. Isso ocorre na linha ```response = middleware.do_request('pipefy', query, 'GET')```. Na sequência, o passo é processar a resposta (i.e. response) que retornou do middleware. Isso é implementado com a linha ```expected_card = Pipefy::Card.parse(response, 'find')```. Esse é o fluxo completo da implementação da integração. Agora é hora de rodar o teste e ir corrigindo os erros.

```
1) Pipefy::Card quando chamar find(id) retornar o card específico pelo id
     Failure/Error: query = query_builder.build('pipefy', 'card', 'find', {id: expected_id})
     
     NameError:
       undefined local variable or method `query_builder' for #<RSpec::ExampleGroups::PipefyCard::QuandoChamarFindId:0x00007fb67e4bfa50>
     # ./spec/lib/pipefy/card_spec.rb:16:in `block (3 levels) in <top (required)>'
```

A variável query_builder não está definida em lugar algum. Vamos definir ela, como um objeto da classe QueryBuilder.

```ruby
it 'retornar o card específico pelo id' do
  query_builder = QueryBuilder.new
  
  expected_id = rand(1..5000)
  query = query_builder.build('pipefy', 'card', 'find', {id: expected_id})
  response = middleware.do_request('pipefy', query, 'POST')
  expected_card = Pipefy::Card.parse(response, 'find')

  card = Pipefy::Card.find(expected_id)
  expect(card.id).to eq expected_card.id
end
```

O próximo erro então é o seguinte:

```
Failures:

  1) Pipefy::Card quando chamar find(id) retornar o card específico pelo id
     Failure/Error: query_builder = QueryBuilder.new
     
     NameError:
       uninitialized constant QueryBuilder
     # ./spec/lib/pipefy/card_spec.rb:15:in `block (3 levels) in <top (required)>'
```

A constante QueryBuilder não está definida. Isso porque nós não fizemos o require do QueryBuilder. Então basta adicionar no topo do arquivo ```require 'query_builder'```. Isso nos leva ao próximo erro:

```
Failures:

  1) Pipefy::Card quando chamar find(id) retornar o card específico pelo id
     Failure/Error: query_placeholder = action_json['query']
     
     NoMethodError:
       undefined method `[]' for nil:NilClass
     # ./lib/query_builder.rb:15:in `build'
     # ./spec/lib/pipefy/card_spec.rb:19:in `block (3 levels) in <top (required)>'
```

O erro agora está em ```/lib/query_builder.rb:15```, isso ocorre porque nós ainda não configuramos nenhuma query para atender ao método find da classe Card. Portanto, o QueryBuilder não sabe como montar a query que está sendo requisitada. Então, o próximo passo é configurarmos a query para consultar um Card por ID. Para isso, devemos editar o arquivo ```config/queries.yml``` e adicionar:

```yml
queries:
  pipefy:
    card:
      find:
        query: '{"query":"{ card(id: \":id\") {title, pipe {id}}}"}'
```

O próximo erro então é o seguinte:

```
1) Pipefy::Card quando chamar find(id) retornar o card específico pelo id
     Failure/Error: response = middleware.do_request('pipefy', query, 'GET')
     
     NameError:
       undefined local variable or method `middleware' for #<RSpec::ExampleGroups::PipefyCard::QuandoChamarFindId:0x00007fd993c21310>
     # ./spec/lib/pipefy/card_spec.rb:20:in `block (3 levels) in <top (required)>'

```

A variável middleware não está definida. Vamos definir a variável com ```middleware = Middleware.instance``` e na parte superior fazer o ```require 'middleware'```.

O próximo erro então aparece:

```
1) Pipefy::Card quando chamar find(id) retornar o card específico pelo id
     Failure/Error: http.headers(headers).post(host, body: query)
     
     WebMock::NetConnectNotAllowedError:
       Real HTTP connections are disabled. Unregistered request: POST https://api.pipefy.com/graphq with body '{"query":"{ card(id: \"2062\") {title, pipe {id}}}"}' with headers {'Accept'=>'application/json', 'Access-Token'=>'put_here_your_credentials', 'Connection'=>'close', 'Content-Type'=>'application/json', 'Host'=>'api.pipefy.com', 'User-Agent'=>'http.rb/4.4.1'}
     
       You can stub this request with the following snippet:
     
       stub_request(:post, "https://api.pipefy.com/graphq").
         with(
           body: "{\"query\":\"{ card(id: \\\"2062\\\") {title, pipe {id}}}\"}",
           headers: {
          'Accept'=>'application/json',
          'Access-Token'=>'put_here_your_credentials',
          'Connection'=>'close',
          'Content-Type'=>'application/json',
          'Host'=>'api.pipefy.com',
          'User-Agent'=>'http.rb/4.4.1'
           }).
         to_return(status: 200, body: "", headers: {})
```

Este erro está dizendo o seguinte: todas as requisições/conexões HTTP reais estão desabilitadas no ambiente de testes e isso é desejável pois não queremos que nossos testes acessem as APIs de verdade. Seguindo no erro, ele menciona que tentou usar uma espécie de simulador para fazer a requisição (esse simulacro é chamado de stub) e, no entanto, não há esse stub registrado. Vamos então corrigir nosso teste e implementar o stub requisitado para simular a requisição HTTP que o middleware está tentando fazer. A implementação do stub e do novo teste fica da seguinte maneira:

```ruby
  context 'quando chamar find(id)' do
    it 'retornar o card específico pelo id' do
      expected_id = rand(1..5000)

      find_card_by_id_response = "{\"data\":{\"card\":{\"id\":#{expected_id}}}}"

      # Stub
      stub_request(:post, "https://api.pipefy.com/graphq").
        with(
          headers: {
          'Connection'=>'close',
          'Host'=>'api.pipefy.com',
          'User-Agent'=>'http.rb/4.4.1'
           }).
      to_return(status: 200, body: find_card_by_id_response, headers: {})

      query_builder = QueryBuilder.new
      middleware = Middleware.instance

      query = query_builder.build('pipefy', 'card', 'find', {id: expected_id})
      response = middleware.do_request('pipefy', query, 'POST')
      expected_card = Pipefy::Card.parse(response, 'find')

      card = Pipefy::Card.find(expected_id)
      expect(card.id).to eq expected_card.id
    end
  end
```

O próximo erro indica que o método parse não foi encontrado na classe Card. Segue abaixo:

```bash
Failures:

  1) Pipefy::Card quando chamar find(id) retornar o card específico pelo id
     Failure/Error: expected_card = Pipefy::Card.parse(response, 'find')
     
     NoMethodError:
       undefined method `parse' for Pipefy::Card:Class
     # ./spec/lib/pipefy/card_spec.rb:36:in `block (3 levels) in <top (required)>'
```

Agora é hora de implementar o método parse para processar a resposta e criar um objeto Card a partir desse processamento. A implementação do método parse é bem simples: ele recebe como parâmetro a resposta da requisição (i.e. os dados que recuperamos da API do Pipefy), faz o processamento e instancia um objeto Card com as informações recuperadas. O código abaixo implementa essa rotina:

```ruby
  def self.parse(response)
    response = JSON.parse(response)
    id = response['data']['card']['id']

    Pipefy::Card.new(id)
  end
```

Após essa implementação, o método find da classe Pipefy::Card está finalizado.




