class EventsController < ApplicationController
  before_filter :load_calendar
  #before_filter :load_user
  filter_resource_access
  
  # GET /events
  # GET /events.xml
  def index
	@events = @calendar.events.paginate(:page => params[:page], :order => 'created_at ASC', :per_page => 3)

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
        format.html { redirect_to([@calendar, @event]) }
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

    respond_to do |format|
			format.html { redirect_to(@calendar) }
      format.xml  { head :ok }
    end
  end
  
  def load_calendar
    @calendar = Calendar.find(params[:calendar_id])
  end
  
  def load_user
    @user = @current_user
  end
  
end
