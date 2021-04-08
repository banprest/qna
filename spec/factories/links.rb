FactoryBot.define do
  factory :link do
    name { "GitHub" }
    url { "https://github.com/" }

    trait :invalid do
      url { '123' }
    end

    trait :gist do
      url { 'https://gist.github.com/banprest/16a49fd807bb77d0032306d78554d4bd'}
    end
  end
end
