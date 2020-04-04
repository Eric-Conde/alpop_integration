# frozen_string_literal: true

def yml2hash(path)
  file = File.read(path)
  yml_file = YAML.safe_load(file)
  yml_seriealized = yml_file.inspect
  JSON.parse yml_seriealized.gsub('=>', ':')
end
