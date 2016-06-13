# encoding: utf-8
# frozen_string_literal: true

# An individual piece of work the completion of which moves the user a step
# closer to achieving a Goal.
class Task < ActiveRecord::Base
  include Deletable
  include Deferrable
  include Completable
  include Classifiable
  include Schedulable

  validates :label, presence: true

  has_many :listings
  has_many :lists, through: :listings
  has_many :subtasks

  serialize :repeat_frequency,  Hash
  serialize :subtask_positions, Array

  def needs_reminding?
    !reminder_at.blank? && reminder_at.future?
  end
end
