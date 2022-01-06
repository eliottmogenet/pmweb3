class ChangeInputTypeTokenNumber < ActiveRecord::Migration[6.0]
  def change
    remove_column :tasks, :token_number, :integer
    add_column :tasks, :token_number, :string
  end
end
