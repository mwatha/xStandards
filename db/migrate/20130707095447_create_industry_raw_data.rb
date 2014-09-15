class CreateIndustryRawData < ActiveRecord::Migration
  def change
    create_table :industry_raw_data do |t|
      t.string :cis_code, :null => false
      t.integer :country_id, :null => false
      t.integer :brand_name_id, :null => false
      t.integer :salt_brand_id, :null => false
      t.string :other, :null => true
      t.float :iodine_level, :null => false
      t.string :category, :null => false
      t.date :date, :null => false

      t.timestamps
    end
  end

  def self.down                                                                 
    drop_table :industry_raw_data
  end

end
