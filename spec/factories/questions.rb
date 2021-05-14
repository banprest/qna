FactoryBot.define do
  sequence :title do |n|
    "title#{n}"
  end
  factory :question do
    title { "MyString" }
    body { "MyText" }
    
    trait :invalid do
      title { nil }
    end

    trait :questions do
      title
    end
  end
end
