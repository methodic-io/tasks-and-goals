# encoding: utf-8
# frozen_string_literal: true

FactoryGirl.define do
  factory :group do
    label          Faker::Lorem.sentence
    open           Faker::Boolean.boolean
    position       Faker::Number.digit
    list_positions (1..10).to_a
  end
end
