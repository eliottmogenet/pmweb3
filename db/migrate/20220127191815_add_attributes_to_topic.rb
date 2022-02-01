class AddAttributesToTopic < ActiveRecord::Migration[6.0]
  def change
    add_column :topics, :name, :string
    add_column :topics, :rules, :text
    add_column :topics, :description, :text
    add_column :topics, :can_create_task, :boolean
    add_column :topics, :can_assign_task, :boolean
    add_column :topics, :can_vote, :boolean
    add_column :topics, :infinite, :boolean
    add_reference :topics, :project
  end
end
