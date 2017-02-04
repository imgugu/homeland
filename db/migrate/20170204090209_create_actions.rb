# This migration comes from action_store (originally 20170204035500)
class CreateActions < ActiveRecord::Migration[5.0]
  def change
    create_table :actions do |t|
      t.string :action_type, null: false
      t.string :action_option
      t.string :target_type
      t.integer :target_id
      t.integer :user_id

      t.timestamps
    end

    add_index :actions, [:user_id, :action_type]
    add_index :actions, [:target_type, :target_id, :action_type]

    add_column :users, :followers_count, :integer, default: 0
    add_column :users, :following_count, :integer, default: 0
  end
end
