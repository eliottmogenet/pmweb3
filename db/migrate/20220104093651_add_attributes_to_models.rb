class AddAttributesToModels < ActiveRecord::Migration[6.0]
  def change
    add_column :employers, :name, :string
    add_column :projects, :name, :string
    add_column :tasks, :title, :string
    add_column :tasks, :status, :string
    add_column :tasks, :token_number, :integer
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_reference :users, :employer
    add_reference :user_projects, :user
    add_reference :user_projects, :project
    add_reference :tasks, :project
    add_reference :tasks, :user
  end
end
