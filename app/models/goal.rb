# encoding: utf-8
# frozen_string_literal: true

# The object of ambition and effort. The completeion of associated tasks move
# the user closer to the desired achievement.
class Goal < ActiveRecord::Base
  include Deletable

  validates :label,      presence:     true
  validates :position,   numericality: { greater_than_or_equal_to: 0 }
  validates :position,   numericality: { only_integer: true }
  validates :difficulty, numericality: { only_integer: true }
  validates :difficulty, inclusion:    { in: 0..5 }
  validates :difficulty, exclusion:    { in: [-1, 6] }
  validates :importance, numericality: { only_integer: true }
  validates :importance, inclusion:    { in: 0..3 }
  validates :importance, exclusion:    { in: [-1, 4] }
  validates :urgency,    numericality: { only_integer: true }
  validates :urgency,    inclusion:    { in: 0..3 }
  validates :urgency,    exclusion:    { in: [-1, 4] }

  belongs_to :focus
  has_many   :lists

  serialize :deferred_at, Array

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

  def smart?
    specific? && measurable? && attainable? && relevant? && timely?
  end
end
