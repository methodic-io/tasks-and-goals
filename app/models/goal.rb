# encoding: utf-8
# frozen_string_literal: true

# The object of ambition and effort. The completeion of associated tasks move
# the user closer to the desired achievement.
class Goal < ActiveRecord::Base
  include Classifiable
  include Completable
  include Deferrable
  include Deletable
  include Positionable
  include Schedulable

  validates :label, presence: true

  belongs_to :focus
  has_many   :lists

  def smart?
    specific? && measurable? && attainable? && relevant? && timely?
  end
end
