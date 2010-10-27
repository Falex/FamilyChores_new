class CalendarsController < ApplicationController
  before_filter :authenticate
  before_filter :load_user
  filter_resource_access

  # GET /calendars
  # GET /calendars.xml
  def index
		@login = @user.login
		@family_id = @user.fam_id
		@family = Fam.find(@family_id)
		@calendars = @family.users[0].calendars
		@user_session = params[:user_session]
		@count = @user.calendars.count

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @calendars }
    end
  end

  # GET /calendars/1
  # GET /calendars/1.xml
  def show
		@login = @user.login
		@family = Fam.find(@user.fam_id)
		@calendar = @family.calendar
		@entries = @calendar.events;
		@users = User.all(:conditions => {:fam_id => @user.fam_id}) # die whole Family
		generate_ics
		
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @calendar }
			format.ics { render :ics => @calendar }
    end
  end

  # GET /calendars/new
  # GET /calendars/new.xml
  def new
    @calendar = Calendar.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @calendar }
    end
  end

  # GET /calendars/1/edit
  def edit
    @calendar = Calendar.find(params[:id])
  end

  # POST /calendars
  # POST /calendars.xml
  def create
    
		@family_id = @user.fam_id
		@family = Fam.find(@family_id)
		@calendar = @user.calendars.build(params[:calendar])
		@calendar.fam_id =  @family.id

    respond_to do |format|
      if @calendar.save
        flash[:notice] = 'Calendar was successfully created.'
        format.html { redirect_to(calendars_path) }
        format.xml  { render :xml => @calendar, :status => :created, :location => @calendar }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @calendar.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /calendars/1
  # PUT /calendars/1.xml
  def update
    @calendar = Calendar.find(params[:id])

    respond_to do |format|
      if @calendar.update_attributes(params[:calendar])
        flash[:notice] = 'Calendar was successfully updated.'
        format.html { redirect_to(@calendar) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @calendar.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /calendars/1
  # DELETE /calendars/1.xml
  def destroy
    @calendar = Calendar.find(params[:id])
    @calendar.destroy

    respond_to do |format|
      format.html { redirect_to(calendars_path) }
      format.xml  { head :ok }
    end
  end
  
  def authenticate
	unless current_user
	  redirect_to account_url
	end
  end
  
  def load_user
    @user = @current_user
  end
	
	def generate_ics
  
		@events = @user.fam.calendar.events
		#FileUtils.mkdir_p (RAILS_ROOT + "/public/system/ical/#{@user.fam.id}")
		#my_file = File.new(File.join(RAILS_ROOT, "public/system/ical/#{@user.fam.id}/famcalendar.ics"), "w")
		FileUtils.mkdir_p(RAILS_ROOT + "/ical/#{@user.fam.id}")
		my_file = File.new(File.join(RAILS_ROOT, "ical/#{@user.fam.id}/famcalendar.ics"), "w")
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
	
	def update_position
	
	end
  
end
