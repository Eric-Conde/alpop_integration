# frozen_string_literal: true

require 'parser'
require 'superlogica/cobranca'

# Parser to process Superlogica Cobranca responses.
class SuperlogicaCobrancaParser < Parser
  def self.parse_find(response)
    id = response[0]['compo_recebimento'][0]['id_boleto_comp'].to_i
    Superlogica::Cobranca.new(id)
  end

  def self.parse_all(response)
    cobrancas = []
    cobrancas_json = response['data'][0]

    cobrancas_json.each do |cobranca|
      compo_recebimento = cobranca['compo_recebimento'][0]
      id_boleto_comp = compo_recebimento['id_boleto_comp']

      cobranca = Superlogica::Cobranca.new(id_boleto_comp)
      cobrancas << cobranca
    end
    cobrancas
  end

  def self.parse_atrasadas(response)
    cobrancas_json = response['data'][0]
    cobrancas = []

    cobrancas_json.each do |cobranca|
      id_boleto_comp = cobranca['id_recebimento_recb']
      dt_vencimento_recb = cobranca['dt_vencimento_recb']

      cobranca = Superlogica::Cobranca.new(id_boleto_comp)
      cobranca.vencimento = dt_vencimento_recb

      cobrancas << cobranca
    end
    cobrancas
  end
end
