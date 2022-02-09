class ChangeDescriptionInProjects < ActiveRecord::Migration[6.0]
  def change
    change_column :projects, :description, :text
  end
end
