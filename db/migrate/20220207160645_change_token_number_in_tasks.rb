class ChangeTokenNumberInTasks < ActiveRecord::Migration[6.0]
  def change
    Task.where(token_number: nil).update_all(token_number: 0)
    Task.where(token_number: "").update_all(token_number: 0)
    change_column :tasks, :token_number, :integer, using: "CAST(token_number AS integer)", default: 0
  end
end
