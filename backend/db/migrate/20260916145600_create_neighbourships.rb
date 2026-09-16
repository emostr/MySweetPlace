class CreateNeighbourships < ActiveRecord::Migration[8.1]
  def change
    create_table :neighbourships do |t|
      t.references :place, null: false, foreign_key: { on_delete: :cascade }, index: false
      t.references :neighbour, null: false, foreign_key: { to_table: :places, on_delete: :cascade }
      t.string :label
      t.integer :position, null: false, default: 0
      t.timestamps
    end
    add_index :neighbourships, %i[place_id neighbour_id], unique: true
  end
end
