# encoding: utf-8
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Group do
  let(:subject) { build(:group) }

  it { should respond_to(:label) }
  it { should respond_to(:open) }
  it { should respond_to(:position) }
  it { should respond_to(:list_positions) }

  it { should validate_presence_of(:label) }
  it { should validate_numericality_of(:position).only_integer }

  it do
    should validate_numericality_of(:position)
      .is_greater_than_or_equal_to(0)
  end

  it { should have_many(:lists).through(:groupings) }

  describe '#label' do
    it { expect(subject.label).to be_a(String) }
  end

  describe '#open' do
    it { expect(subject.open).to be_boolean }
  end

  describe '#position' do
    it { expect(subject.position).to be_an(Integer) }
  end

  describe '#list_positions' do
    it { expect(subject.list_positions).to be_an(Array) }
    it do
      expect(subject.list_positions.map(&:class).uniq)
        .to match_array([Fixnum])
    end
  end
end
