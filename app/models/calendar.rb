class Calendar < ActiveRecord::Base
  has_many :events, :dependent => :destroy
  has_many :chores, :dependent => :destroy
  has_many :rewards, :dependent => :destroy
  #has_many :users
  #belongs_to :users
  belongs_to :fam
	#has_many :configurations
  
  validates_presence_of :title
  validates_length_of :title, :minimum => 3
  validates_length_of :title, :maximum => 40
	
	def createDefaultChores(calendar)
		chore_params = {:title => "Staubwischen",:image => File.new(File.join(RAILS_ROOT, "/public/images/Kalender/Icons", "Staubwischen.png"))}
		@chore = calendar.chores.build(chore_params)
		@chore.save
		chore_params = {:title => "Blumen giessen", :image => File.new(File.join(RAILS_ROOT, "/public/images/Kalender/Icons", "Blumen.png"))}
		@chore = calendar.chores.build(chore_params)
		@chore.save
		chore_params = {:title => "Muell bringen", :image => File.new(File.join(RAILS_ROOT, "/public/images/Kalender/Icons", "Muell.png"))}
		@chore = calendar.chores.build(chore_params)
		@chore.save
		chore_params = {:title => "Waesche waschen",:image => File.new(File.join(RAILS_ROOT, "/public/images/Kalender/Icons", "Wasche.png"))}
		@chore = calendar.chores.build(chore_params)
		@chore.save
		chore_params = {:title => "Tiere putzen", :image => File.new(File.join(RAILS_ROOT, "/public/images/Kalender/Icons", "Tiere.png"))}
		@chore = calendar.chores.build(chore_params)
		@chore.save
	end

end
