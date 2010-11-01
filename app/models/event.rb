class Event < ActiveRecord::Base
	#acts_as_list
  belongs_to :calendar
  belongs_to :user
  belongs_to :chore
  
	validates_presence_of :chore_id
  validates_length_of :description, :maximum => 40
end
