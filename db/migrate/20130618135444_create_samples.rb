class CreateSamples < ActiveRecord::Migration
  def change
    create_table :samples do |t|
      t.string :batch_number, :null => false
      t.integer :product_id, :null => false
      t.float :iodine_level, :null => false
      t.string :category, :null => false
      t.date :date, :null => false

      t.timestamps
    end
  end

  def self.down                                                                 
    drop_table :samples
  end

end
