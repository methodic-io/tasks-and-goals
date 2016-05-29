class AddLabelNoteAndPositionToFoci < ActiveRecord::Migration
  def change
    add_column :foci, :label,    :string
    add_column :foci, :note,     :text
    add_column :foci, :position, :integer
  end
end
