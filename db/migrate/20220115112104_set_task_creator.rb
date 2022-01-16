class SetTaskCreator < ActiveRecord::Migration[6.0]
  def change
    add_reference :tasks, :creator, foreign_key: { to_table: :users }
  end
end
