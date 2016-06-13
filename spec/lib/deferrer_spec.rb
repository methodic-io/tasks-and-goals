# encoding: utf-8
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Deferrer do
  let(:subject)  { described_class }
  let(:duration) { rand(2..10).days }

  describe '.batch_defer' do
    it 'defers an array of same class deferables by the same duration' do
      deferrables = [build(:task), build(:task), build(:task)]

      expect { subject.batch_defer(deferrables, duration) }
        .to change { deferrables.map { |d| d.due_at.to_s } }
        .by([duration.from_now.to_s] * deferrables.count)
    end

    it 'defers an array of mixed class deferables by the same duration' do
      deferrables = [build(:task), build(:goal), build(:task)]

      expect { subject.batch_defer(deferrables, duration) }
        .to change { deferrables.map { |d| d.due_at.to_s } }
        .by([duration.from_now.to_s] * deferrables.count)
    end

    it 'raises an error when given a non deferrable object' do
      deferrables = [build(:task), build(:goal), build(:focus)]

      expect { subject.batch_defer(deferrables, duration) }
        .to raise_error(TypeError)
    end
  end
end
