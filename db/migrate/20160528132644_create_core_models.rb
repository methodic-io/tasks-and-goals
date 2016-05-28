class CreateCoreModels < ActiveRecord::Migration
  def change
    [:foci, :goals, :groups, :lists, :subtasks, :tasks].each do |table|
      create_table table do |t|
        t.timestamps
        t.datetime :deleted_at
      end
    end
  end
end
