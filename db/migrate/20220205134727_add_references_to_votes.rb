class AddReferencesToVotes < ActiveRecord::Migration[6.0]
  def change
    add_reference :votes, :task
    add_reference :votes, :user
  end
end
