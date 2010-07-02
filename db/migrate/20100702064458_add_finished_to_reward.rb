class AddFinishedToReward < ActiveRecord::Migration
  def self.up
    add_column :rewards, :finished, :boolean
  end

  def self.down
    remove_column :rewards, :finished
  end
end
