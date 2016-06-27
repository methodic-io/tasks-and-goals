# encoding: utf-8
# frozen_string_literal: true

# An individual piece of work the completion of which moves the user a step
# closer to achieving a Goal.
class Task < ActiveRecord::Base
  include Classifiable
  include Completable
  include Deferrable
  include Deletable
  include Ensurable
  include Remindable
  include Schedulable

  validates :label, presence: true

  has_many :listings
  has_many :lists, through: :listings do
    def <<(value)
      super(value)
      value.tasks << proxy_association.owner
      value.save!
    end

    def delete(value)
      value.tasks.delete(proxy_association.owner)
      value.save!
      super(value)
    end
  end

  has_many :subtasks do
    def <<(value)
      super(value)
      value = [value] unless value.is_a? Array
      proxy_association.owner.subtask_positions =
        value.map(&:id) + proxy_association.owner.subtask_positions
    end

    def delete(value)
      proxy_association.owner.subtask_positions.delete(value.id)
      super(value)
    end
  end

  serialize :subtask_positions, Array

  def complete
    super
    if repeat_frequency.to_i > 0
      clone             = TaskCloner.clone(self)
      clone.due_at      = Time.current + repeat_frequency
      clone.reminder_at = reminder_at + repeat_frequency if reminder_at
      clone.save!
    end
    clear_reminder
    self
  end

  def repeat_frequency
    duration = super || 0
    duration.seconds
  end

  def repeat_frequency=(duration)
    super(duration.to_i)
  end

  def lists=(new_lists)
    old_lists = lists.to_a
    super(new_lists)
    (old_lists - new_lists).each do |l|
      l.tasks.delete(self)
      l.save!
    end
    (new_lists - old_lists).each do |l|
      l.tasks << self
      l.save!
    end
  end

  def subtasks=(new_subtasks)
    self.subtask_positions = new_subtasks.map(&:id)
    super(new_subtasks)
  end

  def position_subtask(subtask, position)
    ensure_arguments_are_the_correct_class(__method__, Subtask, subtask)
    ensure_objects_are_associated(__method__, subtasks, subtask)
    ensure_position_is_in_bounds(__method__, position, subtask_positions.count)

    subtask_positions.delete(subtask.id)
    subtask_positions.insert(position, subtask.id)
  end

  def exchange_positions(subtask_a, subtask_b)
    args = [subtask_a, subtask_b]
    ensure_arguments_are_the_correct_class(__method__, Subtask, *args)
    ensure_objects_are_associated(__method__, subtasks, *args)
    swap_positions(subtask_a.id, subtask_b.id)
  end

  def ordered_subtasks
    subtasks.sort_by do |s|
      subtask_positions.index(s.id)
    end
  end

  private

  def swap_positions(val_a, val_b)
    index_a = subtask_positions.index(val_a)
    index_b = subtask_positions.index(val_b)
    subtask_positions[index_a] = val_b
    subtask_positions[index_b] = val_a
  end
end
