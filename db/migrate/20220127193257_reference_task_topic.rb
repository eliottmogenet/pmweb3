class ReferenceTaskTopic < ActiveRecord::Migration[6.0]
  def change
    add_reference :tasks, :topic
  end
end
