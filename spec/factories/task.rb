# encoding: utf-8
# frozen_string_literal: true

FactoryGirl.define do
  factory :task do
    duration = (1..10).to_a.sample.days

    label            { generate(:label) }
    note             { generate(:note) }
    due_at           { Faker::Time.forward(10) }
    reminder_at      { Faker::Time.forward(10) }
    deferred_at      { [Faker::Time.forward(10), Faker::Time.forward(10)] }
    completed_at     { Faker::Time.forward(10) }
    repeat_frequency { duration }
    difficulty       { Faker::Number.between(0, 5) }
    importance       { Faker::Number.between(0, 3) }
    urgency          { Faker::Number.between(0, 3) }

    trait :undeferred do
      deferred_at []
    end

    trait :not_due do
      due_at nil
    end

    trait :incomplete do
      completed_at nil
    end

    trait :without_reminder do
      reminder_at nil
    end

    trait :with_subtasks do
      subtasks { Array.new(5) { create(:subtask) }.shuffle! }
    end
  end
end
