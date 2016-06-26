# encoding: utf-8
# frozen_string_literal: true

# An individual step, the combination of which make up the activity of a Task.
class Subtask < ActiveRecord::Base
  include Completable
  include Deletable

  validates :label, presence: true

  belongs_to :task

  def task=(new_task)
    return if task == new_task
    unless task.blank?
      task.subtasks.delete(self)
      task.save!
    end
    unless new_task.blank?
      new_task.subtasks << self
      new_task.save!
    end
    super(new_task)
  end
end
