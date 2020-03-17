# frozen_string_literal: true

FactoryBot.define do
  factory :ticket, class: 'Zendesk::Ticket' do
    id { random_integer }
  end
end
