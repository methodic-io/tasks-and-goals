class CreateCoreModels < ActiveRecord::Migration
  def change
    create_table :foci do |t|
    end

    create_table :goals do |t|
    end

    create_table :groups do |t|
    end

    create_table :lists do |t|
    end

    create_table :subtasks do |t|
    end

    create_table :tasks do |t|
    end
  end
end
