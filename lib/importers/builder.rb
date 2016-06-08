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

  def handle_associations(obj_collection_key, position_collection_key, selector)
    associated_data = find(obj_collection_key, selector)

    if associated_data.any?
      assign_associations(associated_data)
      positions_data = find(position_collection_key, selector)
      populate_positions(positions_data.first['values'])
    end
  end

  [:assign_associations, :populate_positions].each do |method|
    define_method(method) do |*_|
      msg = "You must implement #{method} in subclasses of #{self.class}."
      raise NotImplementedError, msg
    end
  end
end
