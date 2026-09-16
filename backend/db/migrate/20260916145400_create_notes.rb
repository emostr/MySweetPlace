class CreateNotes < ActiveRecord::Migration[8.1]
  def change
    create_table :notes do |t|
      t.references :place, null: false, foreign_key: true, index: false
      t.text :body, null: false, default: ""
      t.text :body_html, null: false, default: ""
      t.bigint :image_ids, array: true, null: false, default: []
      t.boolean :pinned, null: false, default: false
      t.timestamps
    end
    add_index :notes, %i[place_id created_at]
  end
end
