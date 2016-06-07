# encoding: utf-8
# frozen_string_literal: true

require_relative './builder'
require_relative './object_factory'

# A utility that takes a hash of properties and builds a List.
class ListBuilder < Builder
  def build
    wrangle_data
    @list = ObjectFactory.new(List).build(@data).instance
    handle_list_associations
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

  def handle_list_associations
    associated_tasks = find('tasks', by_list)

    if associated_tasks.any?
      assign_tasks_to_list(associated_tasks)
      positions_data = find('task_positions', by_list)
      populate_task_positions(positions_data.first['values'])
    end
  end

  def assign_tasks_to_list(tasks_data)
    tasks_data.each do |task_data|
      task_query = { label: task_data['title'],
                     created_at: Time.zone.parse(task_data['created_at']) }
      task = Task.where(task_query).first
      @list.tasks << task
    end
  end

  def populate_task_positions(task_positions)
    task_positions.each do |source_id|
      task_data = @all_data['tasks'].find { |t| t['id'] == source_id }
      next unless task_data
      task = @list.tasks.select(&task_selector(task_data)).first
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
