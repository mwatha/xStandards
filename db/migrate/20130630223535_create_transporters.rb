class CreateTransporters < ActiveRecord::Migration
  def change
    create_table :transporters do |t|
      t.string :name, :null => false
      t.integer :transporter_type, :null => false
      t.text :description

      t.timestamps
    end
  end

  def self.down                                                                 
    drop_table :transporters
  end

end
