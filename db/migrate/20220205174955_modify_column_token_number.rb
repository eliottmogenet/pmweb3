class ModifyColumnTokenNumber < ActiveRecord::Migration[6.0]
  def change
    remove_column :tasks, :token_number
    add_column :tasks, :token_number, :string, :default => "0"
  end
end
