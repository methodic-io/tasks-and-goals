# encoding: utf-8
# frozen_string_literal: true

FactoryGirl.define do
  factory :list do
    label { generate(:label) }
    tasks { Array.new(5) { create(:task) }.shuffle! }

    trait :without_tasks do
      tasks []
    end
  end
end
