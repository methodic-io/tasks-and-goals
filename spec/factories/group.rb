# encoding: utf-8
# frozen_string_literal: true

FactoryGirl.define do
  factory :group do
    label     { generate(:label) }
    open      { Faker::Boolean.boolean }
    position  { Faker::Number.digit }
    lists     { Array.new(5) { create(:list) }.shuffle! }
  end
end
