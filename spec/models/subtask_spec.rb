# encoding: utf-8
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Subtask do
  let(:subject) { build(:subtask) }

  it { should respond_to(:label) }
  it { should respond_to(:position) }
  it { should respond_to(:complete) }

  describe '#label' do
    it { expect(subject.label).to be_a(String) }
  end

  describe '#position' do
    it { expect(subject.position).to be_an(Integer) }
    it { expect(build(:subtask, position: -1)).to_not be_valid }
  end

  describe '#complete' do
    it { expect(subject.complete).to be_boolean }
  end
end
