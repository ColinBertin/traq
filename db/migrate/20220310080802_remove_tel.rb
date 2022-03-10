class RemoveTel < ActiveRecord::Migration[6.1]
  def change
    remove_column :locations, :tel, :integer
    add_column :locations, :tel, :string
  end
end
