class CreateSaltTypes < ActiveRecord::Migration
  def change
    create_table :salt_types do |t|
      t.string :name, :null => false, :unique => true
      t.text :description
      t.boolean :voided, :null => false, :default => false                      
      t.text :void_reason, :null => true              

      t.timestamps
    end
  end

  def self.down                                                                 
    drop_table :salt_types
  end

end
