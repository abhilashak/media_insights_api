class CreateUserSessions < ActiveRecord::Migration[8.1]
  def change
    create_table :user_sessions do |t|
      t.references :user, null: false, foreign_key: true

      t.string :token_digest, null: false

      t.datetime :expires_at, null: false
      t.datetime :revoked_at

      t.string :user_agent
      t.string :ip_address

      t.timestamps
    end

    add_index :user_sessions, :token_digest, unique: true, name: :idx_user_sessions_token_digest
  end
end
