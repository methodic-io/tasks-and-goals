FactoryGirl.define do
  factory :subtask do
    label    Faker::Lorem.words(4)
    position Faker::Number.digit
    complete Faker::Boolean.boolean
  end
end
