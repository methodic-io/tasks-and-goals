# encoding: utf-8
# frozen_string_literal: true

RSpec::Matchers.define :be_boolean do
  match do |actual|
    expect(actual).to satisfy { |x| x == true || x == false }
  end
end
