class ChangeFinishedFromEvents < ActiveRecord::Migration
  def self.up
		change_column :events, :finished, :boolean, :default => false
  end

  def self.down
		change_column :events, :finished, :string
  end
end
