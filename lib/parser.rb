# frozen_string_literal: true

# Parser base class is responsible for parse API HTTP response body.
class Parser
  def self.parse(api, object, response, action)
    response = JSON.parse(response)
    action = "parse_#{action}"
    api = api.capitalize
    object = api + object + 'Parser'

    Object.const_get(object).send(action, response)
  end
end
