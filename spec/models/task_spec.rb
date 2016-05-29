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
  it { should respond_to(:repeat_frequency) }
  it { should respond_to(:complete) }
  it { should respond_to(:difficulty) }
  it { should respond_to(:importance) }
  it { should respond_to(:urgency) }

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

  describe '#repeat_frequency' do
    it { expect(subject.repeat_frequency).to be_an(String) }
  end

  describe '#complete' do
    it { expect(subject.complete).to be_boolean }
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
