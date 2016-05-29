class AddAttributesToGoals < ActiveRecord::Migration
  def change
    add_column :goals, :label,      :string
    add_column :goals, :note,       :text
    add_column :goals, :position,   :integer
    add_column :goals, :due_at,     :datetime
    add_column :goals, :specific,   :boolean, default: false
    add_column :goals, :measurable, :boolean, default: false
    add_column :goals, :attainable, :boolean, default: false
    add_column :goals, :relevant,   :boolean, default: false
    add_column :goals, :timely,     :boolean, default: false
    add_column :goals, :complete,   :boolean, default: false
    add_column :goals, :difficulty, :integer, default: 0
    add_column :goals, :importance, :integer, default: 0
    add_column :goals, :urgency,    :integer, default: 0
  end
end
