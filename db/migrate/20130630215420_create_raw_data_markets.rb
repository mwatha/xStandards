class CreateRawDataMarkets < ActiveRecord::Migration
  def change
    create_table :raw_data_markets do |t|
      t.integer :country_id, :null => false
      t.integer :district_id, :null => false
      t.integer :market_id, :null => false
      t.integer :brand_name_id, :null => false
      t.integer :salt_type_id, :null => false
      t.float :iodine_level, :null => false
      t.string :category, :null => false
      t.date :date, :null => false

      t.timestamps
    end
  end

  def self.down                                                                 
    drop_table :raw_data_markets
  end

end
