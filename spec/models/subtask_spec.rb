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
        .to change { subject.completed_at.to_s }.from('').to(Time.current.to_s)
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
end
