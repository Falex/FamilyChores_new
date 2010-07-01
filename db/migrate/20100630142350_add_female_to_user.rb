class AddFemaleToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :female, :boolean
  end

  def self.down
    remove_column :users, :female
  end
end
