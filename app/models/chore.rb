class Chore < ActiveRecord::Base
  belongs_to :calendar
  belongs_to :user
	
	has_attached_file :image
	
	validates_attachment_presence :image
	validates_attachment_size :image, :less_than => 200.kilobytes
	validates_attachment_content_type :image, :content_type => ['image/jpeg', 'image/png']
									
  
  validates_presence_of :title
  #validates_presence_of :image_url
  validates_length_of :title, :minimum => 3
  validates_length_of :title, :maximum => 40
  #validates_length_of :image_url, :minimum => 3
  #validates_length_of :image_url, :maximum => 40
end
