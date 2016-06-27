# encoding: utf-8
# frozen_string_literal: true

FactoryGirl.define do
  factory :focus do
    label    { generate(:label) }
    note     { generate(:note) }
    position { Faker::Number.digit }
  end
end
