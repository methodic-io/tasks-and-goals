FactoryGirl.define do
  factory :focus do
    label    Faker::Lorem.words(4)
    note     Faker::Lorem.paragraph
    position Faker::Number.digit
  end
end
