class CreateMovements < ActiveRecord::Migration[7.1]
  def change
    create_table :movements do |t|
      t.references :armeiro, foreign_key: { to_table: :guards }
      t.references :guard, foreign_key: { to_table: :guards }
      t.references :weapon, null: false, foreign_key: true
      t.string :movement_type, null: false  # será 'loan' ou 'return'
      t.date :date
      t.time :time
      t.integer :ammo_count
      t.string :ammo_caliber
      t.integer :magazine_count
      t.text :justification

      t.timestamps
    end
  end
end
