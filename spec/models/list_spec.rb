# encoding: utf-8
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe List do
  let(:subject) { create(:list, :with_tasks) }

  it { should respond_to(:label) }
  it { should respond_to(:note) }
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

  describe '#note' do
    it { expect(subject.note).to be_a(String) }
  end

  describe '#task_positions' do
    it { expect(subject.task_positions).to be_an(Array) }
    it do
      expect(subject.task_positions.map(&:class).uniq).to match_array([Fixnum])
    end
  end

  describe '#tasks=' do
    context 'when set to an empty array' do
      it 'sets task_positions to an empty array' do
        expect(subject.task_positions).not_to be_empty
        subject.tasks = []
        expect(subject.task_positions).to be_empty
      end
    end

    context 'when set to an array of tasks' do
      it 'sets task_positions appropriately' do
        new_tasks     = Array.new(5) { create(:task) }.shuffle!
        new_task_ids  = new_tasks.map(&:id)
        subject.tasks = new_tasks
        expect(subject.task_positions).to eq(new_task_ids)
      end
    end

    context 'when set with anything other than an empty array or ' \
      'an array of tasks' do
      it 'raises an error' do
        expect { subject.tasks = [] }.not_to raise_error
        expect { subject.tasks = [create(:task), create(:task)] }
          .not_to raise_error
        expect { subject.tasks = [create(:task), create(:list)] }
          .to raise_error(ActiveRecord::AssociationTypeMismatch)
      end
    end
  end

  describe '#tasks <<' do
    context 'when a task is assigned' do
      it "adds the task's id to the top of task_positions" do
        task = create(:task)
        subject.tasks << task
        expect(subject.task_positions.first).to eq(task.id)
      end
    end

    context 'when an array of tasks are assigned' do
      it "adds the tasks' ids to the top of task_positions" do
        task_a = create(:task)
        task_b = create(:task)
        subject.tasks << [task_a, task_b]
        expect(subject.task_positions.first(2))
          .to eq([task_a.id, task_b.id])
      end
    end

    context 'when anything other than a task is assigned' do
      it 'raises an error' do
        expect { subject.tasks << build(:goal) }
          .to raise_error(ActiveRecord::AssociationTypeMismatch)
      end
    end
  end

  describe '#tasks.delete' do
    context 'when a task is removed' do
      it "removes the task's id from task_positions" do
        task = create(:task)
        subject.tasks << task
        expect(subject.task_positions).to include(task.id)
        subject.tasks.delete(task)
        expect(subject.task_positions).not_to include(task.id)
      end
    end
  end

  describe '#position_task' do
    let(:task)        { subject.tasks.third }
    let(:num_tasks)   { subject.task_positions.count }

    context 'when given an associated task and an in bounds position' do
      context 'when increasing the task position' do
        it 'correctly sets task_positions' do
          orig_positions = subject.task_positions.dup
          subject.position_task(task, 0)
          expect(subject.task_positions[0]).to eq(task.id)
          expect(subject.task_positions[1]).to eq(orig_positions[0])
          expect(subject.task_positions[2]).to eq(orig_positions[1])
          (num_tasks - 3).times do |i|
            id = i + 3
            expect(subject.task_positions[id]).to eq(orig_positions[id])
          end
        end
      end

      context 'when decreasing the task position' do
        it 'correctly sets task_positions' do
          orig_positions = subject.task_positions.dup
          subject.position_task(task, -1)
          expect(subject.task_positions[0]).to eq(orig_positions[0])
          expect(subject.task_positions[1]).to eq(orig_positions[1])
          (num_tasks - 3).times do |i|
            id = i + 2
            expect(subject.task_positions[id]).to eq(orig_positions[id + 1])
          end
          expect(subject.task_positions.last).to eq(task.id)
        end
      end
    end

    context 'when given an out of bounds position' do
      it 'raises an error' do
        too_high_pos = num_tasks
        too_low_pos  = -num_tasks - 1
        expect { subject.position_task(task, too_high_pos) }
          .to raise_error(ArgumentError)
        expect { subject.position_task(task, too_low_pos) }
          .to raise_error(ArgumentError)
      end
    end

    context 'when given an unassociated task' do
      it 'raises an error' do
        expect { subject.position_task(create(:task), 0) }
          .to raise_error(ArgumentError)
      end
    end

    context 'when given anything other than a task' do
      it 'raises an error' do
        expect { subject.position_task(build(:goal), 0) }
          .to raise_error(TypeError)
      end
    end
  end

  describe '#exchange_positions' do
    context 'when given 2 tasks' do
      context 'and neither task belongs to the list' do
        it 'raises an error' do
          task_a = create(:task)
          task_b = create(:task)
          expect { subject.exchange_positions(task_a, task_b) }
            .to raise_error(ArgumentError)
        end
      end

      context 'and one of the two tasks belongs to the list' do
        it 'raises an error' do
          task_a = create(:task)
          task_b = create(:task)
          subject.tasks << task_a
          expect { subject.exchange_positions(task_a, task_b) }
            .to raise_error(ArgumentError)
        end
      end

      context 'and both tasks belongs to the list' do
        it "swaps the tasks' ids in task_positions" do
          task_a = create(:task)
          task_b = create(:task)
          subject.tasks << [task_a, task_b]

          expect(subject.task_positions.first(2))
            .to eq([task_a.id, task_b.id])
          subject.exchange_positions(task_a, task_b)
          expect(subject.task_positions.first(2))
            .to eq([task_b.id, task_a.id])
        end
      end
    end

    context 'when given anything other than two tasks' do
      it 'raises an error' do
        expect { subject.exchange_positions(build(:list), build(:goal)) }
          .to raise_error(TypeError)
      end
    end
  end

  describe '#ordered_tasks' do
    it 'returns the tasks ordered by task_positions' do
      subject.task_positions.shuffle!
      expect(subject.ordered_tasks.map(&:id))
        .to eq(subject.task_positions)
    end
  end

  describe '#groups=' do
    context 'when set to an empty array' do
      it 'removes the list id from each previously assigned' \
         "group's list_positions" do
        groups = Array.new(5) { create(:group) }.shuffle!
        groups.each do |group|
          group.lists << subject
          group.save!
          expect(group.list_positions).to include(subject.id)
        end
        subject.groups = []
        groups.each do |group|
          group.reload
          expect(group.list_positions).not_to include(subject.id)
        end
      end
    end

    context 'when set to an array of groups' do
      it 'removes the list id from each previously assigned' \
         "group's list_positions" do
        groups = Array.new(5) { create(:group) }.shuffle!
        groups.each do |group|
          group.lists << subject
          group.save!
          expect(group.list_positions).to include(subject.id)
        end
        subject.groups = Array.new(5) { create(:group) }.shuffle!
        groups.each do |group|
          group.reload
          expect(group.list_positions).not_to include(subject.id)
        end
      end

      it 'does nothing to the list_positions of groups that were both ' \
         'previously assigned and newly assigned' do
        groups = Array.new(3) { create(:group) }.shuffle!
        subject.groups = (Array.new(5) { create(:group) } + groups).shuffle!
        new_groups     = (Array.new(5) { create(:group) } + groups).shuffle!
        expect { subject.groups = new_groups }.not_to(
          change { groups.map { |l| l.list_positions.index(subject.id) } }
        )
      end

      it "adds the list id to the top of the each group's list_positions" do
        groups = Array.new(5) { create(:group) }.shuffle!
        groups.each do |group|
          expect(group.list_positions).not_to include(subject.id)
        end
        subject.groups = groups
        groups.each do |group|
          expect(group.list_positions.first).to eq(subject.id)
        end
      end
    end

    context 'when set with anything other than an empty array or ' \
      'an array of groups' do
      it 'raises an error' do
        expect { subject.groups = Array.new(5) { create(:goal) }.shuffle! }
          .to raise_error(ActiveRecord::AssociationTypeMismatch)
      end
    end
  end

  describe '#groups <<' do
    context 'when a group is assigned' do
      it "adds the list id to the top of the group's list_positions" do
        subject.groups = Array.new(5) { create(:group) }.shuffle!
        new_group      = create(:group)
        subject.groups << new_group
        expect(new_group.list_positions.first).to eq(subject.id)
      end
    end
  end

  describe '#groups.delete' do
    context 'when a group is removed' do
      it "removes the list id from the group's list_positions" do
        subject.groups = Array.new(5) { create(:group) }.shuffle!
        old_group      = subject.groups.first
        subject.groups.delete(old_group)
        expect(old_group.list_positions).not_to include(subject.id)
      end
    end
  end
end
