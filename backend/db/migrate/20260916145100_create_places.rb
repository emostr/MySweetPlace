class CreatePlaces < ActiveRecord::Migration[8.1]
  def change
    create_table :places do |t|
      t.references :user, null: false, foreign_key: true, index: { unique: true }
      t.citext :username, null: false
      t.jsonb :profile, null: false, default: {}
      t.jsonb :theme, null: false, default: {}
      t.jsonb :settings, null: false, default: {}
      # denormalized from the interests block, used for search
      t.text :interests, array: true, null: false, default: []
      t.boolean :listed, null: false, default: true
      t.datetime :content_updated_at
      t.datetime :suspended_at
      t.timestamps
    end
    add_index :places, :username, unique: true
    add_index :places, :interests, using: :gin
    add_index :places, :content_updated_at
  end
end
