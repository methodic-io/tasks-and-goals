# encoding: utf-8
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Goal do
  it { should respond_to(:label) }
  it { should respond_to(:note) }
  it { should respond_to(:position) }
  it { should respond_to(:due_at) }
  it { should respond_to(:specific) }
  it { should respond_to(:measurable) }
  it { should respond_to(:attainable) }
  it { should respond_to(:releavant) }
  it { should respond_to(:timely) }
  it { should respond_to(:complete) }
  it { should respond_to(:difficulty) }
  it { should respond_to(:importance) }
  it { should respond_to(:urgency) }
end
