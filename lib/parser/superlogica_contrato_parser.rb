# frozen_string_literal: true

require 'parser'
require 'superlogica/contrato'

# Parser to process Superlogica Contrato responses.
class SuperlogicaContratoParser < Parser
  def self.parse_find(response)
    id = response['data'][0]['id_contrato_con'].to_i
    Superlogica::Contrato.new(id)
  end

  def self.parse_all(response)
    contratos = []
    contratos_json = response['data'][0]

    contratos_json.each do |contrato|
      id_contrato_con = contrato['id_contrato_con']

      contrato = Superlogica::Contrato.new(id_contrato_con)
      contratos << contrato
    end
    contratos
  end
end
