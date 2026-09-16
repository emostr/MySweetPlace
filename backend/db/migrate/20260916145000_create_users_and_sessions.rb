class CreateUsersAndSessions < ActiveRecord::Migration[8.1]
  def change
    enable_extension "citext"

    create_table :users do |t|
      t.citext :email_address, null: false
      t.string :password_digest, null: false
      t.string :locale, null: false, default: "ru"
      t.boolean :admin, null: false, default: false
      t.timestamps
    end
    add_index :users, :email_address, unique: true

    create_table :sessions do |t|
      t.references :user, null: false, foreign_key: true
      t.string :ip_address
      t.string :user_agent
      t.timestamps
    end
  end
end
