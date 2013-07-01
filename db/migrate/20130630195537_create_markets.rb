class CreateMarkets < ActiveRecord::Migration
  def change
    create_table :markets do |t|
      t.integer :district_id, :null => false
      t.string :name
      t.text :description

      t.timestamps
    end
  end

  def self.down                                                                 
    drop_table :markets
  end

end
