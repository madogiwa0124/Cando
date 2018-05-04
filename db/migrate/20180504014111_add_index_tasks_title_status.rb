class AddIndexTasksTitleStatus < ActiveRecord::Migration[5.2]
  def change
    add_index :tasks, [:title, :status]
  end
end
