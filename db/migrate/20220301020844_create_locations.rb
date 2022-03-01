class CreateLocations < ActiveRecord::Migration[6.1]
  def change
    create_table :locations do |t|
      t.string :name
      t.string :address
      t.integer :location_type, default: 0
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
