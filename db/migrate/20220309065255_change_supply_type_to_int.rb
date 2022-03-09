class ChangeSupplyTypeToInt < ActiveRecord::Migration[6.1]
  def change
    remove_column :contributions, :supply_type, :string
    add_column :contributions,
    :supply_type, :integer
  end
end
