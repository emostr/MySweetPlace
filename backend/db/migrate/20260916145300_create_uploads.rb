class CreateUploads < ActiveRecord::Migration[8.1]
  def change
    create_table :uploads do |t|
      t.references :place, null: false, foreign_key: true
      t.string :purpose, null: false
      t.integer :width
      t.integer :height
      t.timestamps
    end
  end
end
