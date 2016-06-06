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
        let(:note)           { data['notes'].find(&by_task) }
        let(:reminder_at)    { data['reminders'].find(&by_task) }
        let(:list_finder)    { ->(l) { l['id'] == task_data['list_id'] } }
        let(:list_title)     { data['lists'].find(&list_finder)['title'] }
        let(:title)          { ->(h) { h['title'] } }
        let(:subtask_titles) { data['subtasks'].select(&by_task).map(&title) }
        let(:subtask_positions) { data['subtask_positions'].find(&by_task) }

        it { expect(task.label).to                 eq(task_data['title']) }
        it { expect(task.lists.first.label).to     eq(list_title) }
        it { expect(task.subtasks.map(&:label)).to match_array(subtask_titles) }

        it do
          if subtask_positions.nil?
            expect(task.subtask_positions).to eq([])
          else
            positions      = subtask_positions['values']
            by_position    = -> (h) { positions.include? h['id'] }
            subtask_labels = data['subtasks'].select(&by_position).map(&title)
            subtasks       = Subtask.where("label IN (?)", subtask_labels)
            expect(task.subtask_positions).to match_array(subtasks.map(&:id))
          end
        end

        it do
          if note.nil?
            expect(task.note).to be_nil
          else
            expect(task.note).to eq(note['content'])
          end
        end

        it do
          if reminder_at.nil?
            expect(task.reminder_at).to be_nil
          else
            expect(task.reminder_at).to eq(Time.zone.parse(reminder_at['date']))
          end
        end

        it do
          expect(task.created_at)
            .to eq(Time.zone.parse(task_data['created_at']))
        end
        it do
          expect(task.due_at)
            .to eq(Time.zone.parse(task_data['due_date']))
        end
        it do
          expect(task.completed_at)
            .to eq(Time.zone.parse(task_data['completed_at']))
        end
      end
    end
  end

  describe 'lists' do
    data['lists'].each do |list_data|
      describe "the '#{list_data['title']}' list" do
        let(:list)           { List.where(label: list_data['title']).first }
        let(:by_list)        { ->(h) { h['list_id'] == list_data['id'] } }
        let(:title)          { ->(h) { h['title'] } }
        let(:task_titles)    { data['tasks'].select(&by_list).map(&title) }
        let(:task_positions) { data['task_positions'].find(&by_list) }

        it { expect(list.label).to eq(list_data['title']) }
        it { expect(list.tasks.map(&:label)).to match_array(task_titles) }

        it do
          if task_positions.nil?
            expect(list.task_positions).to eq([])
          else
            positions   = task_positions['values']
            by_position = -> (h) { positions.include? h['id'] }
            task_labels = data['tasks'].select(&by_position).map(&title)
            tasks       = Task.where("label IN (?)", task_labels)
            expect(list.task_positions).to match_array(tasks.map(&:id))
          end
        end
      end
    end
  end

  describe 'subtasks' do
    data['subtasks'].each do |subtask_data|
      describe "the '#{subtask_data['title']}' subtask" do
        let(:subtask)     { Subtask.where(label: subtask_data['title']).first }
        let(:task_finder) { ->(t) { t['id'] == subtask_data['task_id'] } }
        let(:task_title)  { data['tasks'].find(&task_finder)['title'] }

        it { expect(subtask.label).to      eq(subtask_data['title']) }
        it { expect(subtask.task.label).to eq(task_title) }
        it do
          expect(subtask.completed_at)
            .to eq(Time.zone.parse(subtask_data['completed_at']))
        end
      end
    end
  end
end
