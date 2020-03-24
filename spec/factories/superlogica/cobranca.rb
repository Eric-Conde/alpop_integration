# frozen_string_literal: true

FactoryBot.define do
  factory :cobranca, class: 'Superlogica::Cobranca' do
    id { random_integer }
    st_nome_sac { random_string }
  end
end
