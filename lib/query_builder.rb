# frozen_string_literal: true

# Build queries.
class QueryBuilder
  # Constants.
  CONFIG_PATH = 'config/'
  QUERY_FILE = 'queries.yml'
  QUERY_PATH = CONFIG_PATH + QUERY_FILE

  def build(api = nil, object = nil, api_method = nil, params = nil)
    queries = QueryBuilder.yml2json(QUERY_PATH)
    api_json = queries['queries'][api]
    object_json = api_json[object]
    api_method_json = object_json[api_method]
    query_placeholder = api_method_json['query']
    params.each { |key, val| query_placeholder.gsub!(':' + key.to_s, val.to_s) }
    query = query_placeholder
    query
  end

  def self.yml2json(yml_path)
    file = File.read(yml_path)
    yml_file = YAML.safe_load(file)
    yml_seriealized = yml_file.inspect
    JSON.parse yml_seriealized.gsub('=>', ':')
  end
end
