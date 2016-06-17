# encoding: utf-8
# frozen_string_literal: true

FactoryGirl.define do
  factory :list do
    label { generate(:label) }

    trait :with_tasks do
      tasks { Array.new(5) { create(:task) }.shuffle! }
    end
  end
end
