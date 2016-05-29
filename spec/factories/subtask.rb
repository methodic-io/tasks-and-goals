# encoding: utf-8
# frozen_string_literal: true

FactoryGirl.define do
  factory :subtask do
    label    Faker::Lorem.words(4)
    position Faker::Number.digit
    complete Faker::Boolean.boolean
  end
end
