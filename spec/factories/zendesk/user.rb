# frozen_string_literal: true

FactoryBot.define do
  factory :user, class: 'Zendesk::User' do
    id { random_integer }
  end
end
