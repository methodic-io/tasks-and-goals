# encoding: utf-8
# frozen_string_literal: true

# A collection of Lists. The Group helps with the conceptual organisation
# of its Lists.
class Group < ActiveRecord::Base
  include Deletable
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
    ensure_arguments_are_lists(__method__, list)
    ensure_lists_are_associated(__method__, list)
    ensure_position_is_in_bounds(__method__, position)

    list_positions.delete(list.id)
    list_positions.insert(position, list.id)
  end

  def exchange_positions(list_a, list_b)
    ensure_arguments_are_lists(__method__, list_a, list_b)
    ensure_lists_are_associated(__method__, list_a, list_b)

    pos_a = list_positions.index(list_a.id)
    pos_b = list_positions.index(list_b.id)
    list_positions[pos_a] = list_b.id
    list_positions[pos_b] = list_a.id
  end

  def ordered_lists
    lists.sort_by do |s|
      list_positions.index(s.id)
    end
  end

  private

  def ensure_arguments_are_lists(method, *lists)
    lists.each do |list|
      unless list.is_a? List
        msg = "#{self.class}##{method} can only accept lists as arguments."
        raise TypeError, msg
      end
    end
  end

  def ensure_lists_are_associated(method, *lists)
    unless (lists.map(&:id) - list_positions).empty?
      msg = "#{self.class} must be associated with the given list(s) for " \
            "#{method} to work."
      raise ArgumentError, msg
    end
  end

  def ensure_position_is_in_bounds(method, pos)
    if pos >= list_positions.count || pos < -list_positions.count
      msg = "The position,#{pos} , must be in bounds (positive or negative) " \
            "for #{method} to work. The positions array has a count of "      \
            "#{list_positions.count}."
      raise ArgumentError, msg
    end
  end
end
