# encoding: utf-8
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task do
  let(:subject) { build(:task) }

  it { should respond_to(:label) }
  it { should respond_to(:note) }
  it { should respond_to(:position) }
  it { should respond_to(:due_at) }
  it { should respond_to(:reminder_at) }
  it { should respond_to(:deferred_at) }
  it { should respond_to(:completed_at) }
  it { should respond_to(:repeat_frequency) }
  it { should respond_to(:difficulty) }
  it { should respond_to(:importance) }
  it { should respond_to(:urgency) }

  it { should validate_presence_of(:label) }
  it { should validate_numericality_of(:position).only_integer }

  it do
    should validate_numericality_of(:position)
      .is_greater_than_or_equal_to(0)
  end

  it { should validate_numericality_of(:difficulty).only_integer }
  it { should validate_inclusion_of(:difficulty).in_range(0..5) }
  it { should validate_exclusion_of(:difficulty).in_array([-1, 6]) }

  it { should validate_numericality_of(:importance).only_integer }
  it { should validate_inclusion_of(:importance).in_range(0..3) }
  it { should validate_exclusion_of(:importance).in_array([-1, 4]) }

  it { should validate_numericality_of(:urgency).only_integer }
  it { should validate_inclusion_of(:urgency).in_range(0..3) }
  it { should validate_exclusion_of(:urgency).in_array([-1, 4]) }

  it { should have_many(:lists).through(:listings) }
  it { should have_many(:subtasks) }

  describe '#label' do
    it { expect(subject.label).to be_a(String) }
  end

  describe '#note' do
    it { expect(subject.note).to be_a(String) }
  end

  describe '#position' do
    it { expect(subject.position).to be_an(Integer) }
  end

  describe '#due_at' do
    it { expect(subject.due_at).to be_an(ActiveSupport::TimeWithZone) }
  end

  describe '#reminder_at' do
    it { expect(subject.reminder_at).to be_an(ActiveSupport::TimeWithZone) }
  end

  describe '#deferred_at' do
    it { expect(subject.deferred_at).to be_an(Array) }
    it { expect(subject.deferred_at.map(&:class).uniq).to match_array([Time]) }
  end

  describe '#completed_at' do
    it { expect(subject.completed_at).to be_an(ActiveSupport::TimeWithZone) }
  end

  describe '#repeat_frequency' do
    it { expect(subject.repeat_frequency).to be_an(String) }
  end

  describe '#difficulty' do
    it { expect(subject.difficulty).to be_a(Integer) }
  end

  describe '#importance' do
    it { expect(subject.importance).to be_an(Integer) }
  end

  describe '#urgency' do
    it { expect(subject.urgency).to be_an(Integer) }
  end
end
