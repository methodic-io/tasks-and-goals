# encoding: utf-8
# frozen_string_literal: true

require_relative './builder'
require_relative './object_factory'

# A utility that takes a hash of properties and builds a Subtask.
class SubtaskBuilder < Builder
  def build
    wrangle_data
    ObjectFactory.new(Subtask).build(@data).instance.save!
  end

  private

  def wrangle_data
    # Re-map the title attribute to an attribute the Subtask responds to.
    @data['label'] = @data['label'] || @data['title']
  end
end
