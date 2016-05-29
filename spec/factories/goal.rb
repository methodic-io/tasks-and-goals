FactoryGirl.define do
  factory :goal do
    label      Faker::Lorem.words(4)
    note       Faker::Lorem.paragraph
    position   Faker::Number.digit
    due_at     Faker::Time.forward(10)
    specific   Faker::Boolean.boolean
    measurable Faker::Boolean.boolean
    attainable Faker::Boolean.boolean
    relevant   Faker::Boolean.boolean
    timely     Faker::Boolean.boolean
    complete   Faker::Boolean.boolean
    difficulty Faker::Number.between(0, 5)
    importance Faker::Number.between(0, 3)
    urgency    Faker::Number.between(0, 3)
  end
end
