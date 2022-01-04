class ChangeAttributesToModels < ActiveRecord::Migration[6.0]
  def change
    remove_reference :user_projects, :user
    remove_reference :user_projects, :project
    add_reference :projects, :user
    add_reference :projects, :employer
  end
end
