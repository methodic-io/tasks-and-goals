# encoding: utf-8
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task do
  it { should respond_to(:label) }
  it { should respond_to(:note) }
  it { should respond_to(:position) }
  it { should respond_to(:due_at) }
  it { should respond_to(:reminder_at) }
  it { should respond_to(:repeat_frequency) }
  it { should respond_to(:complete) }
  it { should respond_to(:difficulty) }
  it { should respond_to(:importance) }
  it { should respond_to(:urgency) }
end
