class AddUuidToProjects < ActiveRecord::Migration[6.0]
  def change
    add_column :projects, :uuid, :string
  end
end
