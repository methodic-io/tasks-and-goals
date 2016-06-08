# encoding: utf-8
# frozen_string_literal: true

require_relative './builder'
require_relative './object_factory'

# A utility that takes a hash of properties and builds a List.
class ListBuilder < Builder
  def build
    wrangle_data
    @list = ObjectFactory.new(List).build(@data).instance
    handle_associations('tasks', 'task_positions', by_list)
    @list.save!
  end

  private

  def by_list
    -> (h) { h['list_id'] == @data['id'] }
  end

  def wrangle_data
    # Re-map the title attribute to an attribute the List responds to.
    @data['label'] = @data['label'] || @data['title']
  end

  def assign_associations(tasks_data)
    tasks_data.each do |task_data|
      task_query = { label: task_data['title'],
                     created_at: Time.zone.parse(task_data['created_at']) }
      task = Task.where(task_query).first
      @list.tasks << task
    end
  end

  def populate_positions(task_positions)
    task_positions.each do |source_id|
      task_data = @all_data['tasks'].find { |t| t['id'] == source_id }
      next unless task_data
      task = @list.tasks.find(&task_selector(task_data))
      @list.task_positions << task.id if task
    end
  end

  def task_selector(task_data)
    lambda do |t|
      t.label == task_data['title'] &&
        t.created_at == Time.zone.parse(task_data['created_at'])
    end
  end
end
