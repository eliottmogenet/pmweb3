class AddDateToTopic < ActiveRecord::Migration[6.0]
  def change
    add_column :topics, :date, :datetime
    remove_column :topics, :infinite
  end
end
