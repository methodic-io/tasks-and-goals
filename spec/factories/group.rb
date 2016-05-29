# encoding: utf-8
# frozen_string_literal: true

FactoryGirl.define do
  factory :group do
    label    Faker::Lorem.words(4)
    open     Faker::Boolean.boolean
    position Faker::Number.digit
  end
end
