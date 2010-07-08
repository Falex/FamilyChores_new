class User < ActiveRecord::Base
  acts_as_authentic
  belongs_to :fam
  has_many :calendars
  has_many :events, :through => :calendars
  has_many :rewards, :dependent => :destroy
	validates_presence_of :family
	validates_presence_of :family_password
	
  has_attached_file :photo
  validates_attachment_size :photo, :less_than => 100.kilobytes
	validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png']

  def role_symbols
    @role_symbols ||= (roles || []).map {|r| r.to_sym}
  end
	
	def findcolors(fam)
	  colors = {"green" => "green", "blue" => "blue", "pink" => "pink", "red" => "red"}
		@fam = fam
		@users = @fam.users
		@users.each do |u|
			colors.delete(u.color)
		end
		return colors
	end
 
end
