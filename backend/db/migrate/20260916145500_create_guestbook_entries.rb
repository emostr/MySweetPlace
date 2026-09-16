class CreateGuestbookEntries < ActiveRecord::Migration[8.1]
  def change
    create_table :guestbook_entries do |t|
      t.references :place, null: false, foreign_key: { on_delete: :cascade }, index: false
      t.references :author_place, foreign_key: { to_table: :places, on_delete: :nullify }
      t.string :author_name, null: false
      t.text :body, null: false
      t.string :status, null: false, default: "visible"
      t.boolean :pinned, null: false, default: false
      t.timestamps
    end
    add_index :guestbook_entries, %i[place_id status created_at]
  end
end
