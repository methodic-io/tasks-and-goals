# encoding: utf-8
# frozen_string_literal: true

# An individual step, the combination of which make up the activity of a Task.
class Subtask < ActiveRecord::Base
  include Deletable

  validates :label, presence: true

  belongs_to :task

  def complete
    self.completed_at = Time.current
    self
  end

  def completed?
    !completed_at.blank?
  end
end
