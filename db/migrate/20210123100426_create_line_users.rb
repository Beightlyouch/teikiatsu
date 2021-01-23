class CreateLineUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :line_users do |t|
      t.string :line_id, null: false
      t.timestamps
    end
  end
end
