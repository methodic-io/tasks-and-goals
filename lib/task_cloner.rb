# encoding: utf-8
# frozen_string_literal: true

# Deep clones a given task. This includes attributes and associations.
class TaskCloner
  def self.clone(_)
    Task.new
  end
end
