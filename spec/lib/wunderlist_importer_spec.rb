# encoding: utf-8
# frozen_string_literal: true

require 'rails_helper'
require 'wunderlist_importer'

RSpec.describe WunderlistImporter do
  importer = WunderlistImporter.new(WUNDERLIST_EXPORT)
  data     = importer.input['data']

  importer.import(truncate_existing_data: true)

  describe 'tasks' do
    data['tasks'].each do |task_data|
      describe "the '#{task_data['title']}' task" do
        let(:task)           { Task.where(label: task_data['title']).first }
        let(:by_task)        { ->(h) { h['task_id'] == task_data['id'] } }
        let(:note)           { data['notes'].find(&by_task)['content'] }
        let(:reminder_at)    { data['reminders'].find(&by_task)['date'] }
        let(:list_finder)    { ->(l) { l['id'] == task_data['list_id'] } }
        let(:list_title)     { data['lists'].find(&list_finder) }
        let(:subtask_titles) { data['subtasks'].select(&by_task).map(&:title) }
        let(:subtask_positions) do
          data['subtask_positions'].select(&by_task)['values']
        end

        it { expect(task.label).to        eq(task_data['title']) }
        it { expect(task.created_at).to   eq(task_data['created_at']) }
        it { expect(task.due_at).to       eq(task_data['due_date']) }
        it { expect(task.reminder_at).to  eq(reminder_at) }
        it { expect(task.completed_at).to eq(task_data['completed_at']) }
        it { expect(task.note).to         eq(note) }
        it { expect(task.list.label).to   eq(list_title) }
        it { expect(task.subtasks.map(&:label)).to match_array(subtask_titles) }
        it { expect(task.subtask_positions).to match_array(subtask_positions) }
      end
    end
  end

  describe 'lists' do
    data['lists'].each do |list_data|
      describe "the '#{list_data['title']}' list" do
        let(:list)        { List.where(label: list_data['title']).first }
        let(:by_list)     { ->(h) { h['list_id'] == list_data['id'] } }
        let(:task_titles) { data['tasks'].find(&by_list).map(&:title) }
        let(:task_positions) do
          data['task_positions'].select(&by_list)['values']
        end

        it { expect(task.label).to eq(task_data['title']) }
        it { expect(list.tasks.map(&:label)).to match_array(task_titles) }
        it { expect(task.task_positions).to eq(task_positions) }
      end
    end
  end

  describe 'subtasks' do
    data['subtasks'].each do |subtask_data|
      describe "the '#{subtask_data['title']}' subtask" do
        let(:subtask)     { Subtask.where(label: subtask_data['title']).first }
        let(:task_finder) { ->(t) { t['id'] == subtask_data['task_id'] } }
        let(:task_title)  { data['tasks'].find(&task_finder) }

        it { expect(subtask.label).to      eq(subtask_data['title']) }
        it { expect(subtask.task.label).to eq(task_title) }
      end
    end
  end
end
