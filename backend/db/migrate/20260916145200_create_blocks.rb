class CreateBlocks < ActiveRecord::Migration[8.1]
  def change
    create_table :blocks do |t|
      t.references :place, null: false, foreign_key: { on_delete: :cascade }, index: false
      t.string :kind, null: false
      t.integer :position, null: false, default: 0
      t.boolean :visible, null: false, default: true
      t.jsonb :title, null: false, default: {}
      t.jsonb :data, null: false, default: {}
      t.jsonb :style, null: false, default: {}
      t.timestamps
    end
    add_index :blocks, %i[place_id position]
  end
end
