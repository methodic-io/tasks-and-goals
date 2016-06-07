# encoding: utf-8
# frozen_string_literal: true

FactoryGirl.define do
  factory :list do
    positions = (1..10).to_a

    label          Faker::Lorem.sentence
    task_positions positions
  end
end
