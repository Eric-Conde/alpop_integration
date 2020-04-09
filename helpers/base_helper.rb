# frozen_string_literal: true

def get_api(klass)
  klass.split('::')[1] ? klass.split('::')[0].downcase : nil
end

def get_object(klass)
  klass.split('::')[1].downcase || klass.downcase
end
