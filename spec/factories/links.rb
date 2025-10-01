# frozen_string_literal: true

FactoryBot.define do
  factory :link do
    target_url do
      Faker::Internet.url(
        host: Faker::Internet.domain_name,
        scheme: %w[http https].sample
      )
    end
    sequence(:code) { |n| "#{Faker::Alphanumeric.alphanumeric(number: 5)}#{n.to_s(36)}" }
    clicks_count { 0 }
    expires_at { nil }

    # -------- Traits -------
    trait :expired do
      expires_at { 1.day_ago }
    end

    trait :expiring_soon do
      expires_at { 2.days.from_now }
    end

    trait :with_clicks do
      clicks_count { Faker::Number.between(from: 1, to: 50) }
    end

    trait :no_code do
      code { nil }
    end
  end
end
