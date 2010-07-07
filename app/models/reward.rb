class Reward < ActiveRecord::Base
  belongs_to :user
  belongs_to :calendar
	
	validates_presence_of :title
  validates_length_of :title, :minimum => 3
end
