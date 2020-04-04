require 'parser'
require 'superlogica/locatario'

class SuperlogicaLocatarioParser < Parser
  def self.parse_find(response)
    data = response['data'][0]
    id_pessoa_pes = data['id_pessoa_pes'].to_i

    Superlogica::Locatario.new(id_pessoa_pes)
  end
end
