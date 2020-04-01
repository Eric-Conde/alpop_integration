# frozen_string_literal: true

FactoryBot.define do
  factory :contrato, class: 'Superlogica::Contrato' do
    id { random_integer }
  end
end
