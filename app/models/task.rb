# encoding: utf-8
# frozen_string_literal: true

# An individual piece of work the completion of which moves the user a step
# closer to achieving a Goal.
class Task < ActiveRecord::Base
  include Classifiable
  include Completable
  include Deferrable
  include Deletable
  include Remindable
  include Schedulable

  validates :label, presence: true

  has_many :listings
  has_many :lists, through: :listings
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

  def subtasks=(subtasks)
    self.subtask_positions = subtasks.map(&:id)
    super(subtasks)
  end

  def position_subtask(subtask, position)
    ensure_arguments_are_subtasks(__method__, subtask)
    ensure_subtasks_are_associated(__method__, subtask)
    ensure_position_is_in_bounds(__method__, position)

    subtask_positions.delete(subtask.id)
    subtask_positions.insert(position, subtask.id)
  end

  def exchange_positions(subtask_a, subtask_b)
    ensure_arguments_are_subtasks(__method__, subtask_a, subtask_b)
    ensure_subtasks_are_associated(__method__, subtask_a, subtask_b)

    pos_a = subtask_positions.index(subtask_a.id)
    pos_b = subtask_positions.index(subtask_b.id)
    subtask_positions[pos_a] = subtask_b.id
    subtask_positions[pos_b] = subtask_a.id
  end

  def ordered_subtasks
    subtasks.sort_by do |s|
      subtask_positions.index(s.id)
    end
  end

  private

  def ensure_arguments_are_subtasks(method, *subtasks)
    subtasks.each do |subtask|
      unless subtask.is_a? Subtask
        msg = "#{self.class}##{method} can only accept Subtasks as arguments."
        raise TypeError, msg
      end
    end
  end

  def ensure_subtasks_are_associated(method, *subtasks)
    unless (subtasks.map(&:id) - self.subtasks.map(&:id)).empty?
      msg = "#{self.class} must be associated with the given subtask(s) for " \
            "#{method} to work."
      raise ArgumentError, msg
    end
  end

  def ensure_position_is_in_bounds(method, pos)
    if pos >= subtask_positions.count || pos < -subtask_positions.count
      msg = "The position,#{pos} , must be in bounds (positive or negative) " \
            "for #{method} to work. The positions array has a count of "      \
            "#{subtask_positions.count}."
      raise ArgumentError, msg
    end
  end
end
