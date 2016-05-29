FactoryGirl.define do
  factory :list do
    label    Faker::Lorem.words(4)
    position Faker::Number.digit
  end
end
