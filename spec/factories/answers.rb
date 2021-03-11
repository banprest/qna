FactoryBot.define do
  sequence :body do |n|
    "body#{n}"
  end
  factory :answer do
    body { "MyAnswer" }

    trait :invalid do
      body { nil }
    end

    trait :answers do
      body
    end
  end
end
