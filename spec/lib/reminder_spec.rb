# encoding: utf-8
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Reminder do
  before do
    Resque.reset_delayed_queue
  end

  shared_examples_for 'an unnecessary reminder' do
    it "doesn't queue a ReminderJob" do
      expect(Resque.delayed_queue_schedule_size).to eq(0)
    end

    it 'returns a helpful value' do
      expect(Reminder.setup(task)).to eq(:this_task_does_not_need_a_reminder)
    end
  end

  describe '.setup' do
    context "when the given task's reminder_at is in the future" do
      let(:task) { build(:task, reminder_at: 1.day.from_now) }

      context 'when the task has not been saved' do
        it 'returns a helpful value' do
          expect(Reminder.setup(task))
            .to eq(:this_task_needs_reminding_but_lacks_an_id)
        end
      end

      context 'when the task has been saved' do
        it 'adds a ReminderJob to the reminders queue' do
          task.save!
          Reminder.setup(task)
          expect(ReminderJob)
            .to have_scheduled(task_id: task.id).at(task.reminder_at)
        end
      end
    end

    context "when the given task's reminder_at is in the past" do
      let(:task) { create(:task, reminder_at: 1.day.ago) }

      it_behaves_like 'an unnecessary reminder'
    end

    context "when the given task's reminder_at is blank" do
      let(:task) { create(:task, reminder_at: nil) }

      it_behaves_like 'an unnecessary reminder'
    end
  end
end
