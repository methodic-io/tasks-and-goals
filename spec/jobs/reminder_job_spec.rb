# encoding: utf-8
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReminderJob, type: :job do
  let(:subject) { described_class }
  let(:task)    { create(:task) }

  describe '.perform' do
    it 'sends an email' do
      expect { subject.perform(task_id: task.id) }
        .to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end
end
