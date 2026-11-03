class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.references :account, null: false, foreign_key: true

      t.string :name,  null: false
      t.string :email, null: false
      t.string :password_digest, null: false

      t.timestamps
    end

    add_index :users, "LOWER(email)", unique: true, name: :idx_users_lower_email
  end
end
