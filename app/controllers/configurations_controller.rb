class ConfigurationsController < ApplicationController
  before_filter :authenticate
  before_filter :load_user
	before_filter :load_calendar
  filter_resource_access

  def index
    @users = User.all(:conditions => {:fam_id => @user.fam_id})
	  calendar = Calendar.first(:conditions => {:fam_id => @user.fam_id})
		@rewards = Reward.all(:conditions => {:calendar_id => calendar.id})
		@events = Event.all(:conditions => {:calendar_id => calendar.id})
		@chores = Chore.all(:conditions => {:calendar_id => calendar.id})
		
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @configurations }
    end
  end

  # GET /events/1
  # GET /events/1.xml
  def show
		@users = User.all(:conditions => {:fam_id => @user.fam_id})
	  calendar = Calendar.first(:conditions => {:fam_id => @user.fam_id})
		@rewards = Reward.all(:conditions => {:calendar_id => calendar.id})
		@events = Event.all(:conditions => {:calendar_id => calendar.id})
		@chores = Chore.all(:conditions => {:calendar_id => calendar.id})
		
	
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @configuration }
    end
  end
  
 
  
  def load_user
    @user = @current_user
  end
  
  def authenticate
		unless current_user
			redirect_to account_url
		end
  end
	
	def load_calendar
    @calendar = Calendar.find(params[:calendar_id])
  end
end
