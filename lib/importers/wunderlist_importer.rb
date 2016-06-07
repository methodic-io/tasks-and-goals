# encoding: utf-8
# frozen_string_literal: true

require_relative './importer'
require_relative './subtask_builder'
require_relative './task_builder'
require_relative './list_builder'

# A utility that takes the location of a Wunderlist export JSON file,
# parses its content, amnd imports the content into the DB.
class WunderlistImporter < Importer
  def import(*args)
    super
    import_subtasks
    import_tasks
    import_lists
    notify "#{@data['subtasks'].count} subtasks have been imported."
    notify "#{@data['tasks'].count} tasks have been imported."
    notify "#{@data['lists'].count} lists have been imported."
    notify 'Import process complete.'
  end

  private

  def import_subtasks
    @data['subtasks'].each do |subtask_data|
      SubtaskBuilder.new(subtask_data).build
    end
  end

  def import_tasks
    @data['tasks'].each do |task_data|
      TaskBuilder.new(task_data, @data).build
    end
  end

  def import_lists
    @data['lists'].each do |list_data|
      ListBuilder.new(list_data, @data).build
    end
  end
end
