class IcalfilesController < ApplicationController

	before_filter :load_user, :except => [:download]

  def index
		@events = @user.fam.calendar.events
		@users = @user.fam.users

    respond_to do |format|
			format.html # index.html.erb
			format.xml  
    end
  end
  
  #def show
		#@users = @user.fam.users
		#respond_to do |format|
		#	format.html # show.html.erb 
    #  format.xml  { render :xml => @icalfiles }
    #end
  #end
	
	def download
		@user = User.first(:conditions => {:id => params[:user_id], :password_salt => params[:to]})
		#@user = User.find(params[:family_password])
		@family = Fam.first(:conditions => {:token => params[:to]})
		if !@user.blank?
			render :file => "#{RAILS_ROOT}/ical/#{@user.fam.id}/#{@user.login}_calendar.ics"
		elsif !@family.blank?
			render :file => "#{RAILS_ROOT}/ical/#{@family.id}/famcalendar.ics"
		else
			render :nothing => true
		end
	end
	
	def load_user
    @user = @current_user
  end
end
