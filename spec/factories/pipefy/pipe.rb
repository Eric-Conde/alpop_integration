# frozen_string_literal: true

FactoryBot.define do
  factory :pipe, class: 'Pipefy::Pipe' do
    id { random_integer }
  end
end
