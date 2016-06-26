# encoding: utf-8
# frozen_string_literal: true

# A collection of Tasks. The List helps with the conceptual organisation
# of its Tasks.
class List < ActiveRecord::Base
  include Deletable

  validates :label, presence: true

  belongs_to :goal
  has_many   :groupings
  has_many   :groups, through: :groupings do
    def <<(value)
      super(value)
      value.lists << proxy_association.owner
      value.save!
    end

    def delete(value)
      value.lists.delete(proxy_association.owner)
      value.save!
      super(value)
    end
  end
  has_many   :listings
  has_many   :tasks, through: :listings do
    def <<(value)
      super(value)
      value = [value] unless value.is_a? Array
      proxy_association.owner.task_positions =
        value.map(&:id) + proxy_association.owner.task_positions
    end

    def delete(value)
      proxy_association.owner.task_positions.delete(value.id)
      super(value)
    end
  end

  serialize :task_positions, Array

  def groups=(new_groups)
    old_groups = groups.to_a
    super(new_groups)
    (old_groups - new_groups).each do |g|
      g.lists.delete(self)
      g.save!
    end
    (new_groups - old_groups).each do |g|
      g.lists << self
      g.save!
    end
  end

  def tasks=(tasks)
    self.task_positions = tasks.map(&:id)
    super(tasks)
  end

  def position_task(task, position)
    ensure_arguments_are_tasks(__method__, task)
    ensure_tasks_are_associated(__method__, task)
    ensure_position_is_in_bounds(__method__, position)

    task_positions.delete(task.id)
    task_positions.insert(position, task.id)
  end

  def exchange_positions(task_a, task_b)
    ensure_arguments_are_tasks(__method__, task_a, task_b)
    ensure_tasks_are_associated(__method__, task_a, task_b)

    pos_a = task_positions.index(task_a.id)
    pos_b = task_positions.index(task_b.id)
    task_positions[pos_a] = task_b.id
    task_positions[pos_b] = task_a.id
  end

  def ordered_tasks
    tasks.sort_by do |s|
      task_positions.index(s.id)
    end
  end

  private

  def ensure_arguments_are_tasks(method, *tasks)
    tasks.each do |task|
      unless task.is_a? Task
        msg = "#{self.class}##{method} can only accept tasks as arguments."
        raise TypeError, msg
      end
    end
  end

  def ensure_tasks_are_associated(method, *tasks)
    unless (tasks.map(&:id) - self.tasks.map(&:id)).empty?
      msg = "#{self.class} must be associated with the given task(s) for " \
            "#{method} to work."
      raise ArgumentError, msg
    end
  end

  def ensure_position_is_in_bounds(method, pos)
    if pos >= task_positions.count || pos < -task_positions.count
      msg = "The position,#{pos} , must be in bounds (positive or negative) " \
            "for #{method} to work. The positions array has a count of "      \
            "#{task_positions.count}."
      raise ArgumentError, msg
    end
  end
end
