class RankingsController < ApplicationController

  #before_filter :load_calendar
  before_filter :load_user
  filter_resource_access
  
  # GET /rankings
  # GET /rankings.xml
  def index
    
	@rankings = User.all(:order => 'entire_stars_count DESC', :conditions => {:fam_id => @user.fam_id})

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @rankings }
    end
  end

  def load_user
    @user = @current_user
  end
  

end
