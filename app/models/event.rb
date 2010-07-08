class Event < ActiveRecord::Base
  belongs_to :calendar
  belongs_to :user
  belongs_to :chore, :dependent => :destroy
  
	validates_presence_of :chore_id
  validates_length_of :description, :maximum => 40
end
