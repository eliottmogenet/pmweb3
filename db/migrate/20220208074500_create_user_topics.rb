class CreateUserTopics < ActiveRecord::Migration[6.0]
  def change
    create_table :user_topics do |t|
      t.boolean :seen, default: false
      t.datetime :seen_at
      t.references :user, foreign_key: true
      t.references :topic, null: false, foreign_key: true
      t.string :user_ip

      t.timestamps
    end
  end
end
