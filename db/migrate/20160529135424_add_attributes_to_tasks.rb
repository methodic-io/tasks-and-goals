class AddAttributesToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :label,            :string
    add_column :tasks, :note,             :text
    add_column :tasks, :position,         :integer
    add_column :tasks, :due_at,           :datetime
    add_column :tasks, :reminder_at,      :datetime
    add_column :tasks, :repeat_frequency, :string
    add_column :tasks, :complete,         :boolean, default: false
    add_column :tasks, :difficulty,       :integer, default: 0
    add_column :tasks, :importance,       :integer, default: 0
    add_column :tasks, :urgency,          :integer, default: 0
  end
end
