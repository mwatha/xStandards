class CreateRawDataMarkets < ActiveRecord::Migration
  def change
    create_table :raw_data_markets do |t|
      t.integer :manufacturer_id, :null => false
      t.integer :county_id, :null => false
      t.integer :sub_county_id, :null => false
      t.integer :market_id, :null => false
      t.integer :salt_brand_id, :null => false
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
