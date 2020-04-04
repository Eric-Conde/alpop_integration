# frozen_string_literal: true

FactoryBot.define do
  factory :locatario, class: 'Superlogica::Locatario' do
    id { random_integer }
    id_sacado_sac { random_integer }
  end
end
