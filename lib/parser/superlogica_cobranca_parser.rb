require 'parser'
require 'superlogica/cobranca'
require 'byebug'

class SuperlogicaCobrancaParser < Parser
  def self.parse_find(response)
    id = response[0]['compo_recebimento'][0]['id_boleto_comp'].to_i
    Superlogica::Cobranca.new(id)
  end

  def self.parse_all(response)
    cobrancas = []
    data = response['data'][0]
    
    data.each do |cobranca|
      compo_recebimento = cobranca['compo_recebimento'][0]
      id_boleto_comp = compo_recebimento['id_boleto_comp']
      
      cobranca = Superlogica::Cobranca.new(id_boleto_comp)
      cobrancas << cobranca
    end
    cobrancas
  end
end
