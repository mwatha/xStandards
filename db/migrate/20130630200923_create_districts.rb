class CreateDistricts < ActiveRecord::Migration
  def change
    create_table :districts do |t|
      t.integer :country_id, :null => false
      t.string :name, :null => false
      t.text :description

      t.timestamps
    end
  end
  
  def self.down                                                                 
    drop_table :districts
  end

end
