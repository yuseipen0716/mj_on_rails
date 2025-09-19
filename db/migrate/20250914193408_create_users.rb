class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :unique_id, limit: 20, null: false
      t.string :name, null: false, limit: 50
      t.string :email, limit: 255
      t.string :password_digest

      t.timestamps
    end

    add_index :users, :unique_id, unique: true
    add_index :users, :email, unique: true, where: "email IS NOT NULL"
  end
end
