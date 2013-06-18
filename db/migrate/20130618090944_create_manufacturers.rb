class CreateManufacturers < ActiveRecord::Migration
  def change
    create_table :manufacturers do |t|
      t.string :name, :null => false
      t.integer :country_id, :null => false
      t.text :description

      t.timestamps
    end
  end

  def self.down                                                                 
    drop_table :manufacturers                                                 
  end

end
