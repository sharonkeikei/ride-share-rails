class CreateDrivers < ActiveRecord::Migration[6.0]
  def change
    create_table :drivers do |t|
      t.string :name
      t.string :vin
      t.boolean :available, default: true

      t.timestamps
    end
  end
end
