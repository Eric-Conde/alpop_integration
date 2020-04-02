require 'parser'
require 'superlogica/cobranca'

class SuperlogicaCobrancaParser < Parser
  def self.parse_find(response)
    id = response[0]['compo_recebimento'][0]['id_boleto_comp'].to_i
    Superlogica::Cobranca.new(id)
  end
end
