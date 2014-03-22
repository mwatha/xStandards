class CreateSubCounties < ActiveRecord::Migration
  def change
    create_table :sub_counties do |t|
      t.integer :county_id, :null => false
      t.string :name, :null => false, :unique => true
      t.text :description, :null => true

      t.timestamps
    end
  end

  def self.down                                                                 
    drop_table :sub_counties
  end

end
