# encoding: utf-8
# frozen_string_literal: true

# A collection of Tasks. The List helps with the conceptual organisation
# of its Tasks.
class List < ActiveRecord::Base
  include Deletable
  include Ensurable

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
    ensure_arguments_are_the_correct_class(__method__, Task, task)
    ensure_objects_are_associated(__method__, tasks, task)
    ensure_position_is_in_bounds(__method__, position, task_positions.count)

    task_positions.delete(task.id)
    task_positions.insert(position, task.id)
  end

  def exchange_positions(task_a, task_b)
    ensure_arguments_are_the_correct_class(__method__, Task, task_a, task_b)
    ensure_objects_are_associated(__method__, tasks, task_a, task_b)
    swap_positions(task_a.id, task_b.id)
  end

  def ordered_tasks
    tasks.sort_by do |s|
      task_positions.index(s.id)
    end
  end

  private

  def swap_positions(val_a, val_b)
    index_a = task_positions.index(val_a)
    index_b = task_positions.index(val_b)
    task_positions[index_a] = val_b
    task_positions[index_b] = val_a
  end
end
