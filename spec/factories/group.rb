# encoding: utf-8
# frozen_string_literal: true

FactoryGirl.define do
  factory :group do
    positions = (1..10).to_a

    label          { generate(:label) }
    open           { Faker::Boolean.boolean}
    position       { Faker::Number.digit }
    list_positions positions
  end
end
