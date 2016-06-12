# encoding: utf-8
# frozen_string_literal: true

# An individual piece of work the completion of which moves the user a step
# closer to achieving a Goal.
class Task < ActiveRecord::Base
  include Deletable

  validates :label,      presence:     true
  validates :difficulty, numericality: { only_integer: true }
  validates :difficulty, inclusion:    { in: 0..5 }
  validates :difficulty, exclusion:    { in: [-1, 6] }
  validates :importance, numericality: { only_integer: true }
  validates :importance, inclusion:    { in: 0..3 }
  validates :importance, exclusion:    { in: [-1, 4] }
  validates :urgency,    numericality: { only_integer: true }
  validates :urgency,    inclusion:    { in: 0..3 }
  validates :urgency,    exclusion:    { in: [-1, 4] }

  has_many :listings
  has_many :lists, through: :listings
  has_many :subtasks

  serialize :deferred_at,       Array
  serialize :repeat_frequency,  Hash
  serialize :subtask_positions, Array

  def complete
    self.completed_at = Time.current
    self
  end

  def completed?
    !completed_at.blank?
  end

  def defer(duration = 1.day)
    return self unless due? || overdue?
    deferred_at << Time.current
    self.due_at = duration.from_now
    self
  end

  def deferred?
    deferred_at.any?
  end

  def due?
    !due_at.blank? && due_at.future?
  end

  def overdue?
    !due_at.blank? && due_at.past?
  end

  def needs_reminding?
    !reminder_at.blank? && reminder_at.future?
  end
end
