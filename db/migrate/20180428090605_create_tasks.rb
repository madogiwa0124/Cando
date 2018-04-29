class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.string :title, null: false
      t.text :description
      t.integer :status, null: false, default: Task.statuses[:todo]
      t.integer :priority, null: false, default: Task.priorities[:medium]
      t.datetime :deadline

      t.timestamps
    end
  end
end
