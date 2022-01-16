class AddReferencesToProjectUser < ActiveRecord::Migration[6.0]
  def change
    add_reference :project_users, :user
    add_reference :project_users, :project
  end
end
