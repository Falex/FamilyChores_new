class RewardsController < ApplicationController
  before_filter :load_user
	#before_filter :load_calendar
  # GET /rewards
  # GET /rewards.xml
  def index
		@calendar = Calendar.first(:conditions => {:fam_id => @user.fam_id})
		@rewards = @calendar.rewards

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @rewards }
    end
  end

  # GET /rewards/1
  # GET /rewards/1.xml
  def show
    #@calendar = Calendar.find(params[:calendar_id])
    #@reward = @calendar.rewards.find(params[:id])
		#@rewards = Reward.all

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @reward }
    end
  end

  # GET /rewards/new
  # GET /rewards/new.xml
  def new
    @reward = Reward.new
		points = {1 => 1, 2 => 2, 3 => 3, 5 => 5, 10 => 10, 15 => 15, 20 => 20,30 => 30, 60 => 60}
		@points = points.sort
		
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @reward }
    end
  end

  # GET /rewards/1/edit
  def edit
		@family = Fam.find(@user.fam_id)
		@calendar = @family.users[0].calendars.first
    @reward = Reward.find(params[:id])
		points = {1 => 1, 2 => 2, 3 => 3, 5 => 5, 10 => 10, 15 => 15, 20 => 20,30 => 30, 60 => 60}
		@points = points.sort
  end

  # POST /rewards
  # POST /rewards.xml
  def create
    @calendar = Calendar.find(params[:calendar_id])
    @reward = @calendar.rewards.build(params[:reward])

    respond_to do |format|
      if @reward.save
        flash[:notice] = 'Reward was successfully created.'
        format.html { redirect_to calendar_configurations_path(params[:calendar_id]) }
        format.xml  { render :xml => @reward, :status => :created, :location => @reward }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @reward.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /rewards/1
  # PUT /rewards/1.xml
  def update
    @reward = Reward.find(params[:id])

    respond_to do |format|
      if @reward.update_attributes(params[:reward])
        flash[:notice] = 'Reward was successfully updated.'
        format.html { redirect_to calendar_configurations_path(params[:calendar_id]) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @reward.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /rewards/1
  # DELETE /rewards/1.xml
  def destroy
    @reward = Reward.find(params[:id])
    @reward.destroy

    respond_to do |format|
      format.html {redirect_to calendar_configurations_path(params[:calendar_id])}
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
