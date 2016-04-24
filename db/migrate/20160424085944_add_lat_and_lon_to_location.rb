class AddLatAndLonToLocation < ActiveRecord::Migration
  def change
    add_column :locations, :lat, :decimal, precision: 10, scale: 6
    add_column :locations, :lon, :decimal, precision: 10, scale: 6
  end
end
