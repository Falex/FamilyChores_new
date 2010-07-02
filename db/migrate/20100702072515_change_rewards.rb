class ChangeRewards < ActiveRecord::Migration
  def self.up
		change_column :rewards, :finished, :boolean, :
  end

  def self.down
  end
end
