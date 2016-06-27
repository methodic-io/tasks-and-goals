# encoding: utf-8
# frozen_string_literal: true

# A collection of Lists. The Group helps with the conceptual organisation
# of its Lists.
class Group < ActiveRecord::Base
  include Deletable
  include Ensurable
  include Positionable

  validates :label, presence: true

  has_many :groupings
  has_many :lists, through: :groupings do
    def <<(value)
      super(value)
      value = [value] unless value.is_a? Array
      proxy_association.owner.list_positions =
        value.map(&:id) + proxy_association.owner.list_positions
    end

    def delete(value)
      proxy_association.owner.list_positions.delete(value.id)
      super(value)
    end
  end

  serialize :list_positions, Array

  def lists=(lists)
    self.list_positions = lists.map(&:id)
    super(lists)
  end

  def position_list(list, position)
    ensure_arguments_are_the_correct_class(__method__, List, list)
    ensure_objects_are_associated(__method__, lists, list)
    ensure_position_is_in_bounds(__method__, position, list_positions.count)

    list_positions.delete(list.id)
    list_positions.insert(position, list.id)
  end

  def exchange_positions(list_a, list_b)
    ensure_arguments_are_the_correct_class(__method__, List, list_a, list_b)
    ensure_objects_are_associated(__method__, lists, list_a, list_b)
    swap_positions(list_a.id, list_b.id)
  end

  def ordered_lists
    lists.sort_by do |s|
      list_positions.index(s.id)
    end
  end

  private

  def swap_positions(val_a, val_b)
    index_a = list_positions.index(val_a)
    index_b = list_positions.index(val_b)
    list_positions[index_a] = val_b
    list_positions[index_b] = val_a
  end
end
