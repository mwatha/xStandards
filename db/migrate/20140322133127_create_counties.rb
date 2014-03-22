class CreateCounties < ActiveRecord::Migration
  def change
    create_table :counties do |t|
      t.integer :country_id, :null => false
      t.string :name, :null => false, :unique => true
      t.text :description

      t.timestamps
    end
  end

  def self.down                                                                 
    drop_table :counties                                                 
  end

end
