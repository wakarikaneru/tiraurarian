class AddPedigreeToTiramon < ActiveRecord::Migration[6.1]
  def change
    add_column :tiramons, :pedigree, :text
  end
end
