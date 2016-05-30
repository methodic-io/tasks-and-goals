# encoding: utf-8
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Focus do
  let(:subject) { build(:focus) }

  it { should respond_to(:label) }
  it { should respond_to(:note) }
  it { should respond_to(:position) }

  it { should validate_presence_of(:label) }
  it { should validate_numericality_of(:position).only_integer }

  it do
    should validate_numericality_of(:position)
      .is_greater_than_or_equal_to(0)
  end

  it { should have_many(:goals) }

  describe '#label' do
    it { expect(subject.label).to be_a(String) }
  end

  describe '#note' do
    it { expect(subject.note).to be_a(String) }
  end

  describe '#position' do
    it { expect(subject.position).to be_an(Integer) }
  end
end
