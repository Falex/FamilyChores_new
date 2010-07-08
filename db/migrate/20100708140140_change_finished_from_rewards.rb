class ChangeFinishedFromRewards < ActiveRecord::Migration
  def self.up
		change_column :rewards, :finished, :boolean, :default => false
  end

  def self.down
		change_column :rewards, :finished
  end
end
