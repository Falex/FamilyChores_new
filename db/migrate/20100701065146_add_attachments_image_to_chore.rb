class AddAttachmentsImageToChore < ActiveRecord::Migration
  def self.up
    add_column :chores, :image_file_name, :string
    add_column :chores, :image_content_type, :string
    add_column :chores, :image_file_size, :integer
    add_column :chores, :image_updated_at, :datetime
  end

  def self.down
    remove_column :chores, :image_file_name
    remove_column :chores, :image_content_type
    remove_column :chores, :image_file_size
    remove_column :chores, :image_updated_at
  end
end
