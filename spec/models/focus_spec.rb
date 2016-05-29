# encoding: utf-8
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Focus do
  let(:subject) { build(:focus) }

  it { should respond_to(:label) }
  it { should respond_to(:note) }
  it { should respond_to(:position) }

  describe '#label' do
    it { expect(subject.label).to be_a(String) }
  end

  describe '#note' do
    it { expect(subject.note).to be_a(String) }
  end

  describe '#position' do
    it { expect(subject.position).to be_an(Integer) }
    it { expect(build(:focus, position: -1)).to_not be_valid }
  end
end
