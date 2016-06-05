# encoding: utf-8
# frozen_string_literal: true

FactoryGirl.define do
  factory :list do
    label          Faker::Lorem.sentence
    task_positions (1..10).to_a
  end
end
