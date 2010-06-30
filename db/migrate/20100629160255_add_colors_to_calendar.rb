class AddColorsToCalendar < ActiveRecord::Migration
  def self.up
		add_column :calendars, :green, :boolean
		add_column :calendars, :blue, :boolean
		add_column :calendars, :pink, :boolean
		add_column :calendars, :red, :boolean
  end

  def self.down
		remove_column :calendars, :green
		remove_column :calendars, :blue
		remove_column :calendars, :pink
		remove_column :calendars, :red

  end
end
