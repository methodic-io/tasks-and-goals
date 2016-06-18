# encoding: utf-8
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task do
  let(:subject) { build(:task, :with_subtasks) }

  it { should respond_to(:label) }
  it { should respond_to(:note) }
  it { should respond_to(:due_at) }
  it { should respond_to(:due?) }
  it { should respond_to(:overdue?) }
  it { should respond_to(:reminder_at) }
  it { should respond_to(:needs_reminding?) }
  it { should respond_to(:deferred_at) }
  it { should respond_to(:defer) }
  it { should respond_to(:deferred?) }
  it { should respond_to(:completed_at) }
  it { should respond_to(:complete) }
  it { should respond_to(:completed?) }
  it { should respond_to(:repeat_frequency) }
  it { should respond_to(:difficulty) }
  it { should respond_to(:importance) }
  it { should respond_to(:urgency) }
  it { should respond_to(:subtask_positions) }

  # Task postions are now the responsibility of the parent List
  it { should_not respond_to(:position) }

  it { should validate_presence_of(:label) }

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

  describe '#reminder_at' do
    it { expect(subject.reminder_at).to be_an(ActiveSupport::TimeWithZone) }
  end

  describe '#needs_reminding?' do
    it { expect(subject.needs_reminding?).to be_boolean }

    it do
      subject.reminder_at = 1.week.from_now
      expect(subject.needs_reminding?).to be_truthy
    end

    it do
      subject.reminder_at = 1.week.ago
      expect(subject.needs_reminding?).to be_falsey
    end

    it do
      subject.reminder_at = nil
      expect(subject.needs_reminding?).to be_falsey
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
    let(:subject) { build(:task, :undeferred) }

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
    let(:subject) { build(:task, :incomplete) }

    it { expect(subject.complete).to eq(subject) }

    it do
      expect { subject.complete }
        .to change { subject.completed_at.to_s }.from('').to(Time.current.to_s)
    end
  end

  describe '#completed?' do
    let(:subject) { build(:task, :incomplete) }

    it { expect(subject.completed?).to be_boolean }

    it do
      expect { subject.complete }
        .to change { subject.completed? }.from(false).to(true)
    end
  end

  describe '#repeat_frequency' do
    it { expect(subject.repeat_frequency).to be_an(Hash) }
    it { expect(subject.repeat_frequency.keys).to match_array([:count, :unit]) }
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

  describe '#subtask_positions' do
    it { expect(subject.subtask_positions).to be_an(Array) }
    it do
      expect(subject.subtask_positions.map(&:class).uniq)
        .to match_array([Fixnum])
    end
  end

  describe '#subtasks=' do
    context 'when set to an empty array' do
      it 'sets subtask_positions to an empty array' do
        expect(subject.subtask_positions).not_to be_empty
        subject.subtasks = []
        expect(subject.subtask_positions).to be_empty
      end
    end

    context 'when set to an array of subtasks' do
      it 'sets subtask_positions appropriately' do
        new_subtasks     = Array.new(5) { create(:subtask) }.shuffle!
        new_subtask_ids  = new_subtasks.map(&:id)
        subject.subtasks = new_subtasks
        expect(subject.subtask_positions).to eq(new_subtask_ids)
      end
    end

    context 'when set with anything other than an empty array or ' \
      'an array of subtasks' do
      it 'raises an error' do
        expect { subject.subtasks = [] }.not_to raise_error
        expect { subject.subtasks = [create(:subtask), create(:subtask)] }
          .not_to raise_error
        expect { subject.subtasks = [create(:subtask), create(:task)] }
          .to raise_error(ActiveRecord::AssociationTypeMismatch)
      end
    end
  end

  describe '#subtasks <<' do
    context 'when a subtask is assigned' do
      it "adds the subtask's id to the top of subtask_positions" do
        subtask = create(:subtask)
        subject.subtasks << subtask
        expect(subject.subtask_positions.first).to eq(subtask.id)
      end
    end

    context 'when an array of subtasks are assigned' do
      it "adds the subtasks' ids to the top of subtask_positions" do
        subtask_a = create(:subtask)
        subtask_b = create(:subtask)
        subject.subtasks << [subtask_a, subtask_b]
        expect(subject.subtask_positions.first(2))
          .to eq([subtask_a.id, subtask_b.id])
      end
    end

    context 'when anything other than a subtask is assigned' do
      it 'raises an error' do
        expect { subject.subtasks << build(:goal) }
          .to raise_error(ActiveRecord::AssociationTypeMismatch)
      end
    end
  end

  describe '#subtasks.delete' do
    context 'when a subtask is removed' do
      it "removes the subtask's id from subtask_positions" do
        subtask = create(:subtask)
        subject.subtasks << subtask
        expect(subject.subtask_positions).to include(subtask.id)
        subject.subtasks.delete(subtask)
        expect(subject.subtask_positions).not_to include(subtask.id)
      end
    end
  end

  describe '#position_subtask' do
    let(:subtask)        { subject.subtasks.third }
    let(:num_subtasks)   { subject.subtask_positions.count }

    context 'when given an associated subtask and an in bounds position' do
      context 'when increasing the subtask position' do
        it 'correctly sets subtask_positions' do
          orig_positions = subject.subtask_positions.dup
          subject.position_subtask(subtask, 0)
          expect(subject.subtask_positions[0]).to eq(subtask.id)
          expect(subject.subtask_positions[1]).to eq(orig_positions[0])
          expect(subject.subtask_positions[2]).to eq(orig_positions[1])
          (num_subtasks - 3).times do |i|
            id = i + 3
            expect(subject.subtask_positions[id]).to eq(orig_positions[id])
          end
        end
      end

      context 'when decreasing the subtask position' do
        it 'correctly sets subtask_positions' do
          orig_positions = subject.subtask_positions.dup
          subject.position_subtask(subtask, -1)
          expect(subject.subtask_positions[0]).to eq(orig_positions[0])
          expect(subject.subtask_positions[1]).to eq(orig_positions[1])
          (num_subtasks - 3).times do |i|
            id = i + 2
            expect(subject.subtask_positions[id]).to eq(orig_positions[id + 1])
          end
          expect(subject.subtask_positions.last).to eq(subtask.id)
        end
      end
    end

    context 'when given an out of bounds position' do
      it 'raises an error' do
        too_high_pos = num_subtasks
        too_low_pos  = -num_subtasks - 1
        expect { subject.position_subtask(subtask, too_high_pos) }
          .to raise_error(ArgumentError)
        expect { subject.position_subtask(subtask, too_low_pos) }
          .to raise_error(ArgumentError)
      end
    end

    context 'when given an unassociated subtask' do
      it 'raises an error' do
        expect { subject.position_subtask(create(:subtask), 0) }
          .to raise_error(ArgumentError)
      end
    end

    context 'when given anything other than a subtask' do
      it 'raises an error' do
        expect { subject.position_subtask(build(:goal), 0) }
          .to raise_error(TypeError)
      end
    end
  end

  describe '#exchange_positions' do
    context 'when given 2 tasks' do
      context 'and neither task belongs to the list' do
        it 'should raise an error' do
          subtask_a = create(:subtask)
          subtask_b = create(:subtask)
          expect { subject.exchange_positions(subtask_a, subtask_b) }
            .to raise_error(ArgumentError)
        end
      end

      context 'and one of the two tasks belongs to the list' do
        it 'should raise an error' do
          subtask_a = create(:subtask)
          subtask_b = create(:subtask)
          subject.subtasks << subtask_a
          expect { subject.exchange_positions(subtask_a, subtask_b) }
            .to raise_error(ArgumentError)
        end
      end

      context 'and both tasks belongs to the list' do
        it "should swap the subtasks' ids in subtask_positions" do
          subtask_a = create(:subtask)
          subtask_b = create(:subtask)
          subject.subtasks << [subtask_a, subtask_b]

          expect(subject.subtask_positions.first(2))
            .to eq([subtask_a.id, subtask_b.id])
          subject.exchange_positions(subtask_a, subtask_b)
          expect(subject.subtask_positions.first(2))
            .to eq([subtask_b.id, subtask_a.id])
        end
      end
    end

    context 'when given anything other than two tasks' do
      it 'should raise an error' do
        expect { subject.exchange_positions(build(:task), build(:goal)) }
          .to raise_error(TypeError)
      end
    end
  end

  describe '#ordered_subtasks' do
    it 'should return the subtasks ordered by subtask_positions' do
      subject.subtask_positions.shuffle!
      expect(subject.ordered_subtasks.map(&:id))
        .to eq(subject.subtask_positions)
    end
  end
end
