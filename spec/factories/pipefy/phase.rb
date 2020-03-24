# frozen_string_literal: true

FactoryBot.define do
  factory :phase, class: 'Pipefy::Phase' do
    id { random_integer }
  end
end
