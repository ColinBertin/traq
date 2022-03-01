class RenameSupplyTypeInContributions < ActiveRecord::Migration[6.1]
  def change
    rename_column :contributions, :suply_type, :supply_type
  end
end
