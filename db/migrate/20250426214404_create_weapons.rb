class CreateWeapons < ActiveRecord::Migration[7.1]
  def change
    create_table :weapons do |t|
      t.string :model
      t.string :registration
      t.boolean :borrowed, default: false, null: false

      t.timestamps
    end
  end
end
