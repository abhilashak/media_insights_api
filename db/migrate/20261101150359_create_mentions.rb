class CreateMentions < ActiveRecord::Migration[8.1]
  def change
    create_table :mentions do |t|
      t.references :account, null: false, foreign_key: true

      t.string :title, null: false
      t.string :url, null: false
      t.string :source_type, null: false
      t.datetime :published_at

      t.timestamps
    end

    add_check_constraint :mentions, "source_type IN ('news', 'blog', 'social_media')",
                         name: "mentions_valid_source_type"
  end
end
