FactoryBot.define do
  factory :link do
    name { "GitHub" }
    url { "https://github.com/" }

    trait :invalid do
      url { '123' }
    end
  end
end
