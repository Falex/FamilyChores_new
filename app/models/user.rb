class User < ActiveRecord::Base
  acts_as_authentic
  belongs_to :fam
  has_many :calendars
  has_many :events, :through => :calendars
  has_and_belongs_to_many :rewards
  
  has_attached_file :photo
  validates_attachment_size :photo, :less_than => 100.kilobytes
	validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png']
  
  #attr_accessible :login, :email, :id, :password, :password_confirmation, :role
  
  #def role_symbols
	#[:admin] if role == "admin"
	#[:child] if role == "child"
	#[:parent] if role == "parent"
  #end
  #serialize :roles, Array

  # The necessary method for the plugin to find out about the role symbols
  # Roles returns e.g. [:admin]
  def role_symbols
    @role_symbols ||= (roles || []).map {|r| r.to_sym}
  end
 
end
