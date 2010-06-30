class AddCloudsToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :clouds, :integer
  end

  def self.down
    remove_column :users, :clouds
  end
end
