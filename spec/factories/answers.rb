FactoryBot.define do
  sequence :body do |n|
    "body#{n}"
  end
  factory :answer do
    body { "MyText" }

    trait :invalid do
      body { nil }
    end

    trait :answers do
      body
    end
  end
end
