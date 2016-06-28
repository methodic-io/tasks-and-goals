# encoding: utf-8
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Subtask do
  let(:subject) { build(:subtask) }

  it { should respond_to(:label) }
  it { should respond_to(:completed_at) }
  it { should respond_to(:complete) }
  it { should respond_to(:completed?) }

  # Subtask postions are now the responsibility of the parent Task
  it { should_not respond_to(:position) }

  it { should validate_presence_of(:label) }

  it { should belong_to(:task) }

  describe '#label' do
    it { expect(subject.label).to be_a(String) }
  end

  describe '#completed_at' do
    it { expect(subject.completed_at).to be_an(ActiveSupport::TimeWithZone) }
  end

  describe '#complete' do
    let(:subject) { build(:subtask, :incomplete) }

    it { expect(subject.complete).to eq(subject) }

    it do
      expect { subject.complete }
        .to change { subject.completed_at }
        .from(nil)
        .to be_within(1.second).of Time.current
    end
  end

  describe '#completed?' do
    let(:subject) { build(:subtask, :incomplete) }

    it { expect(subject.completed?).to be_boolean }

    it do
      expect { subject.complete }
        .to change { subject.completed? }.from(false).to(true)
    end
  end

  describe '#task=' do
    context 'when a new task is assigned' do
      it "adds the subtask id to the top of the task's subtask_positions" do
        task = create(:task, :with_subtasks)
        expect(task.subtasks).not_to include(subject)
        expect(task.subtask_positions).not_to be_empty
        expect(task.subtask_positions).not_to include(subject.id)
        expect { subject.task = task }
          .to change { task.subtask_positions.count }.by(1)
        expect(task.subtask_positions.first).to eq(subject.id)
        expect(task.subtasks).to include(subject)
      end
    end

    context 'when the existing task is assigned' do
      it 'does nothing' do
        task = create(:task, :with_subtasks)
        subject.task = task
        expect(task.subtasks).to include(subject)
        expect(task.subtask_positions).not_to be_empty
        expect(task.subtask_positions).to include(subject.id)
        expect { subject.task = task }.not_to change { task.subtask_positions }
        expect(task.subtasks).to include(subject)
      end
    end

    context 'when the existing task is unassigned' do
      it 'removes the subtask id from the previously assigned ' \
         "task's subtask_positions" do
        task = create(:task, :with_subtasks)
        subject.task = task
        expect(task.subtasks).to include(subject)
        expect(task.subtask_positions).not_to be_empty
        expect(task.subtask_positions).to include(subject.id)
        expect { subject.task = nil }
          .to change { task.subtask_positions.count }.by(-1)
        expect(task.subtask_positions).not_to include(subject.id)
        expect(task.subtasks).not_to include(subject)
      end
    end
  end
end
