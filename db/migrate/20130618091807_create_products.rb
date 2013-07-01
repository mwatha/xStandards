class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.integer :manufacturer_id, :null => false
      t.string :name, :null => false
      t.text :description

      t.timestamps
    end
  end

  def self.down                                                                 
    drop_table :products
  end

end
