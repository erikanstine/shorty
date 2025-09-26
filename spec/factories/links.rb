FactoryBot.define do
  factory :link do
    target_url { 'https://example.com' }
    code { 'MyString' }
    clicks_count { 1 }
    expires_at { '2025-09-26 14:17:35' }
  end
end
