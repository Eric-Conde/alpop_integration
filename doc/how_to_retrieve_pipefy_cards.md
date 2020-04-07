## Como recuperar um card específico do Pipefy

### 1. Criar/Incrementar o objeto de domínio Ruby

Iniciar pelos testes para a classe Pipefy::Card (criar o arquivo card_spec.rb em spec/lib/pipefy/). Em princípio, estamos interessados em recuperar os ID (identificadores únicos) dos cards, bem como o título.

```ruby
1: # frozen_string_literal: true
2:
3: require 'pipefy/card'
4: require 'parser'
5:
6:  describe Pipefy::Card do
7:    context 'quando Pipefy::Card for inicializado' do
8:      it 'atribui valor ao id do card' do
9:        card = build :card
10:       expect(card.id).not_to be_nil
11:     end
12:   end
13: end
```

Esse teste indica que existe um atributo id no objeto card, da classe Pipefy::Card, que pode ser preenchido no momento da criação de um objeto. Observe o guard no terminal para ver qual será o primeiro erro.

```bash
1: An error occurred while loading ./spec/lib/pipefy/card_spec.rb. - Did you mean?
2:                  rspec ./spec/lib/pipefy/phase_spec.rb
3:                    rspec ./spec/lib/pipefy/pipe_spec.rb
4:
5: Failure/Error: require 'pipefy/card'
6:
7: LoadError:
8:  cannot load such file -- pipefy/card
9:  # ./spec/lib/pipefy/card_spec.rb:3:in `require'
```

O erro indica problema no arquivo card_spec.rb, na linha 3. A mensagem de erro informa que não foi possível encontrar o arquivo pipefy/card para fazer o require. Portanto, nosso próximo passo será criar o arquivo pipefy/card.rb.

Após criar o arquivo, rodar os testes novamente. O próximo erro deve ser:

```bash
1: An error occurred while loading ./spec/lib/pipefy/card_spec.rb.
2: Failure/Error:
3:   describe Pipefy::Card do
4:    context 'quando Pipefy::Card for inicializado' do
5:      it 'atribui valor ao id do card' do
6:        card = build :card
7:       expect(card.id).not_to be_nil
8:     end
9:   end
10: end
11:
12: NameError:
13:  uninitialized constant Pipefy
14: # ./spec/lib/pipefy/card_spec.rb:6:in `<top (required)>'
```

Esse erro indica problema na linha 6 do arquivo card_spec.rb. O erro menciona que não foi possível reconhecer a constante Pipefy, uma vez que ela não existe. Portanto, o próximo passo é criar essa constante no arquivo da classe card.rb.

```ruby
1: module Pipefy
2: end
```

Ao salvar o arquivo card.rb, verificar o guard no terminal. O próximo erro segue abaixo:

```bash
1: An error occurred while loading ./spec/lib/pipefy/card_spec.rb.
2: Failure/Error:
3:   describe Pipefy::Card do
4:    context 'quando Pipefy::Card for inicializado' do
5:      it 'atribui valor ao id do card' do
6:        card = build :card
7:       expect(card.id).not_to be_nil
8:     end
9:   end
10: end
11:
12: NameError:
13: uninitialized constant Pipefy::Card
14: # ./spec/lib/pipefy/card_spec.rb:6:in `<top (required)>'
```

O próximo erro indica que não foi possível reconhecer a constante Pipefy::Card. Então, para corrigir esse erro basta criar nossa classe Card no módulo Pipefy:

```ruby
1: module Pipefy
2:  class Card < Base
3:  end
4: end
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
4: require 'parser'
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


TO BE CONTINUED...

































