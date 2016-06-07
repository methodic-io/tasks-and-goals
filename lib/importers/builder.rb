# encoding: utf-8
# frozen_string_literal: true

# The base object builder class.
class Builder
  def initialize(instance_data, all_data = {})
    @data     = instance_data
    @all_data = all_data
  end

  protected

  def find(collection_key, selector)
    @all_data[collection_key].select(&selector)
  end
end
