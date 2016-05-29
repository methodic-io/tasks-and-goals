FactoryGirl.define do
  factory :task do
    frequencies = [nil, 'every_day', 'every_week', 'every_month', 'every_year']

    label            Faker::Lorem.words(4)
    note             Faker::Lorem.paragraph
    position         Faker::Number.digit
    due_at           Faker::Date.forward(10)
    reminder_at      Faker::Date.forward(10)
    repeat_frequency frequencies.sample
    complete         Faker::Boolean.boolean
    difficulty       Faker::Number.between(0, 5)
    importance       Faker::Number.between(0, 3)
    urgency          Faker::Number.between(0, 3)
  end
end
