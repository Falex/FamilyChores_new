class AddTokenToFams < ActiveRecord::Migration
  def self.up
		add_column :fams, :token, :string
  end

  def self.down
		remove_column :fams, :token
  end
end
