# encoding: utf-8
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Subtask do
  let(:subject) { build(:subtask) }

  it { should respond_to(:label) }
  it { should respond_to(:completed_at) }

  # Subtask postions are now the responsibility of the parent Task
  it { should_not respond_to(:position) }

  it { should validate_presence_of(:label) }

  it { should belong_to(:task) }

  describe '#label' do
    it { expect(subject.label).to be_a(String) }
  end

  describe '#completed_at' do
    it { expect(subject.completed_at).to be_an(ActiveSupport::TimeWithZone) }
  end
end
