# frozen_string_literal: true

FactoryBot.define do
  factory :locatario, class: 'Superlogica::Locatario' do
    id { random_integer }
    id_sacado_sac { id }
  end
end
