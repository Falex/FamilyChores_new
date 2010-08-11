class IcalfilesController < ApplicationController

	before_filter :load_user

  def index
    #@chores = Chore.all
		#my_file = File.new("famcalendar.ics", "w")
		#my_file.save
		@events = @user.fam.calendar.events
		@users = @user.fam.users
		#render :file => '../../public/system/ical/famcalendar.ics'

    respond_to do |format|
			generate_ics()
			format.html # index.html.erb
			#format.xml  { render :xml => @icalfiles }
    end
  end
  
  def show
		@events = @user.fam.calendar.events
    respond_to do |format|
	  #format.html # show.html.erb
	  format.ics {render :ics => generate_ics() }
      
      #format.xml  { render :xml => @icalfiles }
    end
  end
  
  def generate_ics
  
		@events = @user.fam.calendar.events
		FileUtils.mkdir_p (RAILS_ROOT + "/public/system/ical/#{@user.fam.id}")
		my_file = File.new(File.join(RAILS_ROOT, "public/system/ical/#{@user.fam.id}/famcalendar.ics"), "w")
		my_file.write "BEGIN:VCALENDAR" + "\n"
		
		my_file.write "METHOD:" + "PUBLISH" + "\n"
		@events.each do |event|
			my_file.write "BEGIN:VEVENT" + "\n"
			my_file.write "SUMMARY:" + event.chore.title + " " + event.user.login + "\n"
			my_file.write "DTSTART;VALUE=DATE:" + event.start_on.strftime("%Y%m%d") + "\n"
			my_file.write "DTEND;VALUE=DATE:" + event.start_on.strftime("%Y%m%d") + "\n"
			my_file.write "CATEGORIES:Family" + "\n"
			my_file.write "DESCRIPTION:" + event.description + "\n"
			my_file.write "ATTENDEE;CN=" + event.user.login + "\n"
			my_file.write "SEQUENCE:0" + "\n"
			my_file.write "END:VEVENT" + "\n"
		end
		
		my_file.write "END:VCALENDAR" + "\n"
		my_file.close

		#return my_file
  end
	
	def load_user
    @user = @current_user
  end
end
