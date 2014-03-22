class CreateRawDataQualityMonitorings < ActiveRecord::Migration
  def change
    create_table :raw_data_quality_monitorings do |t|
      t.string :iir_code, :null => false
      t.integer :border_id, :null => false
      t.integer :importer_id, :null => false
      t.integer :salt_brand_id, :null => false
      t.integer :country_id, :null => false
      t.float :volume_of_import, :null => false
      t.float :iodine_level, :null => false
      t.string :category, :null => false
      t.date :date, :null => false

      t.timestamps

      t.timestamps
    end
  end

  def self.down                                                                 
    drop_table :raw_data_quality_monitorings
  end

end
