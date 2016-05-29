class AddAttributesToLists < ActiveRecord::Migration
  def change
    add_column :lists, :label,    :string
    add_column :lists, :position, :integer
  end
end
