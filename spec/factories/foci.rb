# encoding: utf-8
# frozen_string_literal: true

FactoryGirl.define do
  factory :focus do
    label    Faker::Lorem.words(4)
    note     Faker::Lorem.paragraph
    position Faker::Number.digit
  end
end
