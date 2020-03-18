# frozen_string_literal: true

FactoryBot.define do
  factory :card, class: 'Pipefy::Card' do
    id { random_integer }
    title { random_string }
  end
end
