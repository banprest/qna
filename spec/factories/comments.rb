FactoryBot.define do
  factory :comment do
    association :commentable, factory: :question
    association :user, factory: :user

    body { "MyString" }
  end
end
