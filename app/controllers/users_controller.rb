class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:show, :edit, :update]
  
  def new
    @user = User.new
  end
  
  def create
# not good code
		@user = User.new(params[:user])
		@family = Fam.find_by_title(@user.family)	
		@hasCalendar = false
		if !@family.nil?
			 @user.roles = "child"
			 @hasCalendar = true
		else
			 @family = Fam.new(:title => @user.family)
			 @family.save
			 @user.roles = "admin"
		end
		@user.fam_id = @family.id 
			if @user.findcolors(@family).length > 0
				@user.color = @user.findcolors(@family).values[0]
			else
				@user.color = green
			end

# good code
#		@families = Fam.find_or_create_by_title(params[:family])
#		@user = @families.users.build(params[:user])
#		@user.roles = "admin"
		
    if @user.save
			if @hasCalendar == false
				@calendar = Calendar.create!(:title => @user.family, :user_id => @user.id, :fam_id => @family.id)
				@calendar.createDefaultChores(@calendar)
			end
      flash[:notice] = "Account registered!"
      redirect_back_or_default account_url
    else
      render :action => :new
    end
  end
  
  def show
    @user = @current_user
		@presents_got = @user.rewards.all(:conditions => {:finished => true})
		@present = @user.rewards.first(:conditions => {:finished => false})
		stars_count = @user.entire_stars_count
		@stars_gathered = @user.calculatePresentPoints(@presents_got, @present, @user.entire_stars_count)
  end
 
  def edit
    if @current_user.roles == "admin"
			@user = User.find(params[:id], :conditions => {:fam_id => @current_user.fam_id})
		else
			@user = User.find(params[:id])
		end
		@calendar = @user.fam.calendar
		@colors= @user.findcolors(@user.fam).merge!({@user.color => @user.color})
  end
	
  def update
		@user = @current_user
		@colors= @user.findcolors(@user.fam).merge!({@user.color => @user.color})
    if @current_user.roles == "admin"
	    @user = User.find(params[:id], :conditions => {:fam_id => @current_user.fam_id})
		else
			@user = @current_user
		end
    if @user.update_attributes(params[:user])
			@user.fam.update_attributes(params[:family])
      flash[:notice] = "Account updated!"
      redirect_to account_path 
    else
      render :action => :edit
    end
  end
  
  def destroy 
   @user = User.find(params[:id])
   @user.destroy
   flash[:notice] = 'Account deleted!'
   redirect_to root_url
  end
	
	
	public
	
	def addStar
	  @user = User.find(params[:id])
		@event = Event.find(params[:event_id])
		@event.update_attributes(:finished => true)
	  if @user.entire_stars_count.nil?
		  new_count = 1;
	  else
		  new_count = @user.entire_stars_count + 1
	  end
	  if @user.update_attributes(:entire_stars_count => new_count)
			flash[:notice] = "Added star"
	  end
		calendar = Calendar.first(:conditions => {:fam_id => @user.fam_id})
		redirect_to calendar_url(:id => calendar.id)
	end
	
	def addCloud
		@user = User.find(params[:id])
		@event = Event.find(params[:event_id])
		@event.update_attributes(:finished => true)
	  if @user.clouds.nil?
		  new_count = 1;
	  else
		  new_count = @user.clouds + 1
	  end
	  if @user.update_attributes(:clouds => new_count)
			flash[:notice] = "Added cloud"
	  end
		calendar = Calendar.first(:conditions => {:fam_id => @user.fam_id})
		redirect_to calendar_url(:id => calendar.id)
	end
  

end
