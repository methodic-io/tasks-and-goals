# encoding: utf-8
# frozen_string_literal: true

FactoryGirl.define do
  factory :list do
    positions = (1..10).to_a

    label          { generate(:label) }
    task_positions { positions }

    trait :without_tasks do
      task_positions []
    end
  end
end
