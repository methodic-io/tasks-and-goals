# encoding: utf-8
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Wunderlist Export' do
  let(:export) { JSON.parse(File.read(WUNDERLIST_EXPORT)) }

  it 'includes the expected keys' do
    expected_keys = %w(user exported data)
    expect(export.keys).to match_array(expected_keys)
  end

  describe '["data"]' do
    let(:data) { export['data'] }

    it 'includes the expected keys' do
      expected_keys = %w(lists tasks reminders subtasks notes
                         task_positions subtask_positions)
      expect(data.keys).to match_array(expected_keys)
    end

    describe '["lists"]' do
      it 'includes the expected keys' do
        expected_keys = %w(id title owner_type owner_id list_type public
                           revision created_at created_by_request_id type)
        datum = data['lists'].sample
        expect(datum.keys).to match_array(expected_keys)
      end
    end

    describe '["tasks"]' do
      it 'includes the expected keys' do
        expected_keys = %w(id created_at created_by_id created_by_request_id
                           due_date completed completed_at completed_by_id
                           starred list_id revision title type)
        datum = data['tasks'].sample
        expect(datum.keys).to match_array(expected_keys)
      end
    end

    describe '["reminders"]' do
      it 'includes the expected keys' do
        expected_keys = %w(id date task_id revision created_at updated_at
                           created_by_request_id type)
        datum = data['reminders'].sample
        expect(datum.keys).to match_array(expected_keys)
      end
    end

    describe '["subtasks"]' do
      it 'includes the expected keys' do
        expected_keys = %w(id task_id completed completed_at created_at
                           created_by_id created_by_request_id revision
                           title type)
        datum = data['subtasks'].sample
        expect(datum.keys).to match_array(expected_keys)
      end
    end

    describe '["notes"]' do
      it 'includes the expected keys' do
        expected_keys = %w(id revision content type task_id)
        datum = data['notes'].sample
        expect(datum.keys).to match_array(expected_keys)
      end
    end

    describe '["task_positions"]' do
      it 'includes the expected keys' do
        expected_keys = %w(id list_id revision values type)
        datum = data['task_positions'].sample
        expect(datum.keys).to match_array(expected_keys)
      end
    end

    describe '["subtask_positions"]' do
      it 'includes the expected keys' do
        expected_keys = %w(id task_id revision values type)
        datum = data['subtask_positions'].sample
        expect(datum.keys).to match_array(expected_keys)
      end
    end
  end
end
