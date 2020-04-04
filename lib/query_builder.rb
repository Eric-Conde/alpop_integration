# frozen_string_literal: true

# Build queries.
class QueryBuilder
  # Constants.
  CONFIG_PATH = 'config/'
  QUERY_FILE = 'queries.yml'
  QUERY_PATH = CONFIG_PATH + QUERY_FILE

  def build(api = nil, object = nil, action = nil, params = nil)
    queries = QueryBuilder.yml2json(QUERY_PATH)
    api_json = queries['queries'][api]
    object_json = api_json[object]
    action_json = object_json[action]
    query_placeholder = action_json['query']

    QueryBuilder.process_params(params, query_placeholder)

    query = query_placeholder
    query
  end

  def self.yml2json(yml_path)
    file = File.read(yml_path)
    yml_file = YAML.safe_load(file)
    yml_seriealized = yml_file.inspect
    JSON.parse yml_seriealized.gsub('=>', ':')
  end

  def self.process_params(params, query_placeholder)
    params&.each do |key, val|
      query_placeholder.gsub!(':' + key.to_s, val.to_s)
    end
  end
end
