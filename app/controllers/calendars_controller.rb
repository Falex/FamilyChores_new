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
    #@family_id = @user.fam_id
		@login = @user.login
		@family = Fam.find(@user.fam_id)
		@calendar = @family.calendar
		@entries = @calendar.events;
		@user = User.find(@calendar.user_id)
		@users = User.all(:conditions => {:fam_id => @user.fam_id}) # die whole Family
		
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @calendar }
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
  
end
