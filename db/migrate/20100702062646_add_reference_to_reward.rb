class AddReferenceToReward < ActiveRecord::Migration
  def self.up
		add_column :rewards, :user_id, :integer
  end

  def self.down
		remove_column :rewards, :user_id
  end
end
