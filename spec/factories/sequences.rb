# encoding: utf-8
# frozen_string_literal: true

FactoryGirl.define do
  sequence :label do |n|
    "Object Label #{n}"
  end

  sequence :note do |n|
    "#{n} #{Faker::Lorem.paragraph}"
  end
end
