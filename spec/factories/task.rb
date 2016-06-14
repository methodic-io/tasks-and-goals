# encoding: utf-8
# frozen_string_literal: true

FactoryGirl.define do
  factory :task do
    units           = %w(never hours days weeks months years)
    frequency_hash  = { count: (1..10).to_a.sample, unit: units.sample }
    positions       = (1..10).to_a

    label             { generate(:label) }
    note              { generate(:note) }
    due_at            { Faker::Time.forward(10) }
    reminder_at       { Faker::Time.forward(10) }
    deferred_at       { [Faker::Time.forward(10), Faker::Time.forward(10)] }
    completed_at      { Faker::Time.forward(10) }
    repeat_frequency  { frequency_hash }
    difficulty        { Faker::Number.between(0, 5) }
    importance        { Faker::Number.between(0, 3) }
    urgency           { Faker::Number.between(0, 3) }
    subtask_positions { positions }

    trait :undeferred do
      deferred_at []
    end

    trait :not_due do
      due_at nil
    end

    trait :incomplete do
      completed_at nil
    end
  end
end
