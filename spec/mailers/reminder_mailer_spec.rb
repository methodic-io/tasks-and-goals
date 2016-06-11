# encoding: utf-8
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReminderMailer, type: :mailer do
  describe 'reminder_email' do
    let(:task) { build(:task) }
    let(:mail) { described_class.reminder_email(task).deliver_now }

    it 'renders the subject' do
      expect(mail.subject).to eq("Task & Goals Reminder: #{task.label}")
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq(['ed@methodic.io'])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['notifications@methodic.io'])
    end

    it 'includes the task label in the body' do
      expect(mail.body.encoded).to match(task.label)
    end
  end
end
