# encoding: utf-8
# frozen_string_literal: true

FactoryGirl.define do
  factory :task do
    frequencies = ['never', 'daily', 'weekly', 'monthly', 'yearly']

    label            Faker::Lorem.words(4)
    note             Faker::Lorem.paragraph
    position         Faker::Number.digit
    due_at           Faker::Time.forward(10)
    reminder_at      Faker::Time.forward(10)
    repeat_frequency frequencies.sample
    complete         Faker::Boolean.boolean
    difficulty       Faker::Number.between(0, 5)
    importance       Faker::Number.between(0, 3)
    urgency          Faker::Number.between(0, 3)
  end
end
