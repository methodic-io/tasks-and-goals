# encoding: utf-8
# frozen_string_literal: true

FactoryGirl.define do
  factory :list do
    label    Faker::Lorem.sentence
    position Faker::Number.digit
  end
end
