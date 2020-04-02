require 'parser'
require 'superlogica/contrato'

class SuperlogicaContratoParser < Parser
  def self.parse_find(response)
    id = response['data'][0]['id_contrato_con'].to_i
    Superlogica::Contrato.new(id)
  end
end
