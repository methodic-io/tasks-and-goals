# encoding: utf-8
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TaskCloner do
  let(:subject)  { described_class }
  let(:task)     { create(:task) }

  describe '.clone' do
    context 'when given anything other than a task' do
      it 'raises an error' do
        expect { subject.clone(build(:goal)) }.to raise_error(TypeError)
      end
    end

    context 'when given a task' do
      it 'creates a new task with the same attributes where appropriate' do
        new_task = subject.clone(task)

        byebug

        # Attributes that should match.
        expect(new_task.label).to            eq(task.label)
        expect(new_task.note).to             eq(task.note)
        expect(new_task.reminder_at).to      eq(task.reminder_at)
        expect(new_task.repeat_frequency).to eq(task.repeat_frequency)
        expect(new_task.difficulty).to       eq(task.difficulty)
        expect(new_task.importance).to       eq(task.importance)
        expect(new_task.urgency).to          eq(task.urgency)

        # Attributes that should not match.
        expect(new_task.id).not_to           be_nil
        expect(new_task.id).not_to           eq(task.id)
        expect(new_task.deferred_at).to      be_empty
        expect(new_task.deferred_at).not_to  eq(task.deferred_at)
        expect(new_task.completed_at).to     be_nil
        expect(new_task.completed_at).not_to eq(task.completed_at)
      end

      context 'associated with one or more lists' do
        it 'creates a new task associated with the same single list with ' \
           'matching position' do
          list       = create(:list, :without_tasks)
          list.tasks = [create(:task), create(:task), create(:task)]
          task.lists = [create(:list)]
          list.task_positions.shuffle!

          position = list.task_positions.index(task.id)
          new_task = subject.clone(task)

          expect(new_task.lists).to match_array(task.lists)
          expect(list.task_positions.index(new_task.id)).to eq(position)
        end

        it 'creates a new task associated with the same set of lists with ' \
           'matching positions' do
          positions  = []
          lists      = []
          task.lists = []
          num_lists  = 3

          num_lists.times do
            list       = create(:list, :without_tasks)
            list.tasks = [create(:task), create(:task), create(:task)]
            lists      << list
            task.lists << list
            list.task_positions.shuffle!
            positions << list.task_positions.index(task.id)
          end

          new_task = subject.clone(task)

          expect(new_task.lists).to match_array(task.lists)
          num_lists.times do |i|
            expect(lists[i].task_positions.index(new_task.id))
              .to eq(positions[i])
          end
        end
      end

      context 'not associated with any lists' do
        it 'creates a new task that is not associated with any lists' do
          task.lists = []
          new_task   = subject.clone(task)
          expect(new_task.lists).to be_empty
        end
      end

      context 'with subtasks' do
        it 'creates a new task with cloned subtasks with matching positions' do
          task.subtasks = []
          num_subtasks  = 5

          num_subtasks.times do
            task.subtasks << create(:subtask)
          end

          task.subtask_positions.shuffle!
          ordered_subtask_labels = task.subtasks.map(&:label)
          subtask_ids            = task.subtasks.map(&:id)

          new_task = subject.clone(task)

          expect(new_task.subtasks.map(&:label)).to  eq(ordered_subtask_labels)
          expect(new_task.subtasks.map(&:id)).not_to include(*subtask_ids)
          expect(new_task.subtasks.map(&:completed?)).to eq([false])
        end
      end

      context 'without subtasks' do
        it 'creates a new task without any subtasks' do
          task.subtasks = []
          new_task      = subject.clone(task)
          expect(new_task.subtasks).to be_empty
        end
      end
    end
  end
end
