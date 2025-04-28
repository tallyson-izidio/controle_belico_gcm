class CreateGuards < ActiveRecord::Migration[7.1]
  def change
    create_table :guards do |t|
      t.string :full_name
      t.string :matricula
      t.string :porte_numero
      t.references :team, null: false, foreign_key: true

      t.timestamps
    end
  end
end
