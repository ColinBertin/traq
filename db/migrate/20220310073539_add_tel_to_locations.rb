class AddTelToLocations < ActiveRecord::Migration[6.1]
  def change
    add_column :locations, :tel, :integer
  end
end
