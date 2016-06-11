# encoding: utf-8
# frozen_string_literal: true

require 'rails_helper'
require 'resque_spec/scheduler'

RSpec.describe Reminder do
  before do
    ResqueSpec.reset!
  end

  shared_examples_for 'an unnecessary reminder' do
    it "doesn't queue a ReminderJob" do
      expect(ReminderJob).to have_schedule_size_of(0)
    end

    it 'returns a helpful value' do
      expect(Reminder.setup(task)).to eq(:this_task_does_not_need_a_reminder)
    end
  end

  describe '.setup' do
    context "when the given task's reminder_at is in the future" do
      let(:task) { build(:task, reminder_at: 1.day.from_now) }

      it 'adds a ReminderJob to the reminders queue' do
        Reminder.setup(task)
        expect(ReminderJob).to have_scheduled(task.id).at(task.reminder_at)
      end
    end

    context "when the given task's reminder_at is in the past" do
      let(:task) { build(:task, reminder_at: 1.day.ago) }

      it_behaves_like 'an unnecessary reminder'
    end

    context "when the given task's reminder_at is blank" do
      let(:task) { build(:task, reminder_at: nil) }

      it_behaves_like 'an unnecessary reminder'
    end
  end
end
