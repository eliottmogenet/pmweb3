class RemoveEmployerFromProject < ActiveRecord::Migration[6.0]
  def change
    remove_reference :projects, :employer
  end
end
