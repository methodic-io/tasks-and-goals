# encoding: utf-8
# frozen_string_literal: true

# Deep clones a given task. This includes attributes and associations.
class TaskCloner
  def self.clone(task)
    handle_invalid_type(task) unless task.is_a? Task

    clone = task.dup
    clone.deferred_at  = []
    clone.completed_at = nil
    clone.save!
    handle_lists(clone, task)    if task.lists.any?
    handle_subtasks(clone, task) if task.subtasks.any?
    clone
  end

  private_class_method

  def self.handle_invalid_type(task)
    error_msg = "#{self.class} can only apply clone to Tasks. " \
                "#{task.class} is not an instance of Task."
    raise TypeError, error_msg
  end

  def self.handle_lists(clone, task)
    task.lists.each do |list|
      list.tasks << clone
      list.exchange_positions(task, clone)
      list.save!
    end
    clone.save!
  end

  def self.handle_subtasks(clone, task)
    task.ordered_subtasks.reverse.each do |subtask|
      new_subtask = subtask.dup
      new_subtask.completed_at = nil
      clone.subtasks << new_subtask
      new_subtask.save!
    end
    clone.save!
  end
end
