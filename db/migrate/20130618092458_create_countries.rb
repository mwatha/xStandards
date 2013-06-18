class CreateCountries < ActiveRecord::Migration
  def change
    create_table :countries do |t|
      t.string :name, :null => false
      t.text :description

      t.timestamps
    end
  end

  def self.down                                                                 
    drop_table :countries
  end

end
