class EventsController < ApplicationController
  before_filter :load_calendar
  #before_filter :load_user
  #filter_resource_access
  
  # GET /events
  # GET /events.xml
  def index
	@events = @calendar.events(:order => 'created_at ASC')

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @events }
    end
  end

  # GET /events/1
  # GET /events/1.xml
  def show
    @event = Event.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @event }
    end
  end

  # GET /events/new
  # GET /events/new.xml
  def new
    @event = Event.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @event }
    end
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
  end

  # POST /events
  # POST /events.xml
  def create
  @calendar = Calendar.find(params[:calendar_id])
	@event = @calendar.events.build(params[:event])
	@event.finished = 0;
	

    respond_to do |format|
      if @event.save
        flash[:notice] = 'Event was successfully created.'
				ics_for_all #######
				format.html { redirect_to(@calendar) }
				format.xml  { render :xml => @event, :status => :created, :location => @event }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /events/1
  # PUT /events/1.xml
  def update
    @event = Event.find(params[:id])

    respond_to do |format|
      if @event.update_attributes(params[:event])
        flash[:notice] = 'Event was successfully updated.'
				ics_for_all ########
        format.html { redirect_to calendar_configurations_path(params[:calendar_id]) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.xml
  def destroy
    @event = Event.find(params[:id])
    @event.destroy
		ics_for_all #########
    respond_to do |format|
			format.html { redirect_to calendar_configurations_path(params[:calendar_id]) }
      format.xml  { head :ok }
    end
  end
  
  def load_calendar
    @calendar = Calendar.find(params[:calendar_id])
  end
  
  def load_user
    @user = @current_user
  end
	
	def sort
		#@events = Event.all
		#@events.each do |event|
		#	event.start_on = params['.calendar_entry']
		#	event.save
		#end
		unless params[:event].blank?
			params[:event].each_index do |i|
				#logger.info "ID: #{params[:event][i]}" #### wichitg !!!!!!!!!!!!!!
				event = Event.find(params[:event][i].to_i)
				#event.update_attribute(:position, i)
				date = Time.at(params[:date].gsub("calendar_entries_", "").to_i)
				event.update_attribute(:start_on, date)
			end
		end
		render :nothing => true
	end
	
	def ics_for_all
		@current_user.fam.users.each do |user|
			generate_ics(events = user.events, user, false)
		end
		generate_ics(events = @current_user.fam.calendar.events, @current_user, true)
	end
	
	def generate_ics(events, user, family)
		@fam = Fam.all
		@events = events #@user.fam.calendar.events
		FileUtils.mkdir_p(RAILS_ROOT + "/ical/#{user.fam.id}")
		if family == true
			my_file = File.new(File.join(RAILS_ROOT, "ical/#{user.fam.id}/famcalendar.ics"), "w")
		else
			my_file = File.new(File.join(RAILS_ROOT, "ical/#{user.fam.id}/#{user.login}_calendar.ics"), "w")
		end
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
  end
end
