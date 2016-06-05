class RefactorPositionAttributes < ActiveRecord::Migration
  def change
    remove_column :lists,    :position
    remove_column :tasks,    :position
    remove_column :subtasks, :position

    add_column :groups, :list_positions,    :text
    add_column :lists,  :task_positions,    :text
    add_column :tasks,  :subtask_positions, :text
  end
end
