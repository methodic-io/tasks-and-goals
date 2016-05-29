# encoding: utf-8
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Goal do
  let(:subject) { build(:goal) }

  it { should respond_to(:label) }
  it { should respond_to(:note) }
  it { should respond_to(:position) }
  it { should respond_to(:due_at) }
  it { should respond_to(:specific) }
  it { should respond_to(:measurable) }
  it { should respond_to(:attainable) }
  it { should respond_to(:relevant) }
  it { should respond_to(:timely) }
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
    it { expect(build(:goal, position: -1)).to_not be_valid }
  end

  describe '#due_at' do
    it { expect(subject.due_at).to be_an(ActiveSupport::TimeWithZone) }
  end

  describe '#specific' do
    it { expect(subject.specific).to be_boolean }
  end

  describe '#measurable' do
    it { expect(subject.measurable).to be_boolean }
  end

  describe '#attainable' do
    it { expect(subject.attainable).to be_boolean }
  end

  describe '#relevant' do
    it { expect(subject.relevant).to be_boolean }
  end

  describe '#timely' do
    it { expect(subject.timely).to be_boolean }
  end

  describe '#complete' do
    it { expect(subject.complete).to be_boolean }
  end

  describe '#difficulty' do
    it { expect(subject.difficulty).to be_a(Integer) }
    it { expect(build(:goal, difficulty: -1)).to_not be_valid }
    it { expect(build(:goal, difficulty: 0)).to be_valid }
    it { expect(build(:goal, difficulty: 1)).to be_valid }
    it { expect(build(:goal, difficulty: 2)).to be_valid }
    it { expect(build(:goal, difficulty: 3)).to be_valid }
    it { expect(build(:goal, difficulty: 4)).to be_valid }
    it { expect(build(:goal, difficulty: 5)).to be_valid }
    it { expect(build(:goal, difficulty: 6)).to_not be_valid }
  end

  describe '#importance' do
    it { expect(subject.importance).to be_an(Integer) }
    it { expect(build(:goal, importance: -1)).to_not be_valid }
    it { expect(build(:goal, importance: 0)).to be_valid }
    it { expect(build(:goal, importance: 1)).to be_valid }
    it { expect(build(:goal, importance: 2)).to be_valid }
    it { expect(build(:goal, importance: 3)).to be_valid }
    it { expect(build(:goal, importance: 4)).to_not be_valid }
  end

  describe '#urgency' do
    it { expect(subject.urgency).to be_an(Integer) }
    it { expect(build(:goal, urgency: -1)).to_not be_valid }
    it { expect(build(:goal, urgency: 0)).to be_valid }
    it { expect(build(:goal, urgency: 1)).to be_valid }
    it { expect(build(:goal, urgency: 2)).to be_valid }
    it { expect(build(:goal, urgency: 3)).to be_valid }
    it { expect(build(:goal, urgency: 4)).to_not be_valid }
  end
end
