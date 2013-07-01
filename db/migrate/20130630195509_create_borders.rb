class CreateBorders < ActiveRecord::Migration
  def change
    create_table :borders do |t|
      t.integer :country_id, :null => false
      t.string :name, :null => false
      t.text :description

      t.timestamps
    end
  end
  
  def self.down                                                                 
    drop_table :borders                                                    
  end

end
