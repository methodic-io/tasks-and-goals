# encoding: utf-8
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe List do
  let(:subject) { build(:list) }

  it { should respond_to(:label) }
  it { should respond_to(:task_positions) }

  # List postions are now the responsibility of the parent Group
  it { should_not respond_to(:position) }

  it { should validate_presence_of(:label) }

  it { should belong_to(:goal) }
  it { should have_many(:groups).through(:groupings) }
  it { should have_many(:tasks).through(:listings) }

  describe '#label' do
    it { expect(subject.label).to be_a(String) }
  end

  describe '#task_positions' do
    it { expect(subject.task_positions).to be_an(Array) }
    it do
      expect(subject.task_positions.map(&:class).uniq)
        .to match_array([FixNum])
    end
  end
end
