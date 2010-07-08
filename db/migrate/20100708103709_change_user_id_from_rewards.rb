class ChangeUserIdFromRewards < ActiveRecord::Migration
  def self.up
		change_table :rewards do |t| 
			t.remove :user_id
			t.references :user
		end 
  end

  def self.down
			
  end
end
