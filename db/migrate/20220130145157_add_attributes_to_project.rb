class AddAttributesToProject < ActiveRecord::Migration[6.0]
  def change
    add_column :projects, :txt_color, :string, default: "#B45CD2"
    add_column :projects, :description, :string
  end
end
