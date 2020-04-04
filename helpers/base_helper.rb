# frozen_string_literal: true

def get_api_and_caller_object_name(klass)
  object = klass.split('::')[1] || klass
  api = klass.split('::')[1] ? klass.split('::')[0] : nil

  [api, object]
end
