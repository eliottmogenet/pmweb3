class AddNewAttributes < ActiveRecord::Migration[6.0]
  def change
    add_column :tasks, :confidentiality, :string
    add_column :tasks, :topic, :string
    add_column :tasks, :description, :text
  end
end
