# frozen_string_literal: true

FactoryBot.define do
  factory :locatario, class: 'Superlogica::Locatario' do
    id { random_integer }
  end
end
