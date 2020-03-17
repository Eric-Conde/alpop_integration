# frozen_string_literal: true

FactoryBot.define do
  factory :card, class: 'Pipefy::Card' do
    title { random_string }
    pipe_id { random_integer }
  end
end
