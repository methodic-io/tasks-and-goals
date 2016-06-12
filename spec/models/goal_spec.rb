# encoding: utf-8
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Goal do
  let(:subject) { build(:goal) }

  it { should respond_to(:label) }
  it { should respond_to(:note) }
  it { should respond_to(:position) }
  it { should respond_to(:due_at) }
  it { should respond_to(:due?) }
  it { should respond_to(:overdue?) }
  it { should respond_to(:deferred_at) }
  it { should respond_to(:defer) }
  it { should respond_to(:deferred?) }
  it { should respond_to(:completed_at) }
  it { should respond_to(:complete) }
  it { should respond_to(:completed?) }
  it { should respond_to(:specific?) }
  it { should respond_to(:measurable?) }
  it { should respond_to(:attainable?) }
  it { should respond_to(:relevant?) }
  it { should respond_to(:timely?) }
  it { should respond_to(:smart?) }
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

  it { should belong_to(:focus) }
  it { should have_many(:lists) }

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

  describe '#due?' do
    it { expect(subject.due?).to be_boolean }

    it do
      subject.due_at = 1.week.from_now
      expect(subject.due?).to be_truthy
    end

    it do
      subject.due_at = 1.week.ago
      expect(subject.due?).to be_falsey
    end

    it do
      subject.due_at = nil
      expect(subject.due?).to be_falsey
    end
  end

  describe '#overdue?' do
    it { expect(subject.overdue?).to be_boolean }

    it do
      subject.due_at = 1.week.from_now
      expect(subject.overdue?).to be_falsey
    end

    it do
      subject.due_at = 1.week.ago
      expect(subject.overdue?).to be_truthy
    end

    it do
      subject.due_at = nil
      expect(subject.overdue?).to be_falsey
    end
  end

  describe '#deferred_at' do
    it { expect(subject.deferred_at).to be_an(Array) }
    it { expect(subject.deferred_at.map(&:class).uniq).to match_array([Time]) }
  end

  describe '#defer' do
    it { expect(subject.defer).to eq(subject) }

    it do
      expect { subject.defer }.to change { subject.deferred_at.count }.by(1)
      expect(subject.deferred_at.last.to_s).to eq(Time.current.to_s)
    end

    it 'should defer the due_at property to tomorrow by default' do
      expect { subject.defer }.to change { subject.due_at.to_s }
        .to(1.day.from_now.to_s)
    end

    it 'should defer the due_at property by the given duration' do
      duration = rand(2..10).days
      expect { subject.defer(duration) }.to change { subject.due_at.to_s }
        .to(duration.from_now.to_s)
    end

    it 'should do nothing if the due_at property is not set' do
      subject = build(:goal, :not_due)
      expect { subject.defer }.not_to change { subject.deferred_at }
      expect { subject.defer }.not_to change { subject.due_at }
      expect(subject.deferred_at.last.to_s).not_to eq(Time.current.to_s)
    end
  end

  describe '#deferred?' do
    let(:subject) { build(:goal, :undeferred) }

    it { expect(subject.deferred?).to be_boolean }

    it do
      expect { subject.defer }
        .to change { subject.deferred? }.from(false).to(true)
    end
  end

  describe '#completed_at' do
    it { expect(subject.completed_at).to be_an(ActiveSupport::TimeWithZone) }
  end

  describe '#complete' do
    let(:subject) { build(:goal, :incomplete) }

    it { expect(subject.complete).to eq(subject) }

    it do
      expect { subject.complete }
        .to change { subject.completed_at.to_s }.from('').to(Time.current.to_s)
    end
  end

  describe '#completed?' do
    let(:subject) { build(:goal, :incomplete) }

    it { expect(subject.completed?).to be_boolean }

    it do
      expect { subject.complete }
        .to change { subject.completed? }.from(false).to(true)
    end
  end

  describe '#specific?' do
    it { expect(subject.specific?).to be_boolean }
  end

  describe '#measurable?' do
    it { expect(subject.measurable?).to be_boolean }
  end

  describe '#attainable?' do
    it { expect(subject.attainable?).to be_boolean }
  end

  describe '#relevant?' do
    it { expect(subject.relevant?).to be_boolean }
  end

  describe '#timely?' do
    it { expect(subject.timely?).to be_boolean }
  end

  describe '#smart?' do
    methods = %w(specific measurable attainable relevant timely)

    it { expect(subject.timely?).to be_boolean }

    it do
      methods.each { |method| subject.send("#{method}=", true) }
      expect(subject.smart?).to be_truthy
    end

    values = ([true] * (methods.count - 1) + [false] * methods.count)
    values.permutation(methods.count).to_a.uniq.each do |bools|
      it do
        methods.count.times { |i| subject.send("#{methods[i]}=", bools[i]) }
        expect(subject.smart?).to be_falsey
      end
    end
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
