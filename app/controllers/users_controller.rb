class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:show, :edit, :update]
  
  
  def new
    @user = User.new
  end
  
  def create

# bad code
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
		#@family = Fam.find_by_title(@user.family)
		@user.fam_id = @family.id 
		@user.color = findcolor

# good code
#		@families = Fam.find_or_create_by_title(params[:family])
#		@user = @families.users.build(params[:user])
#		@user.roles = "admin"
		
    if @user.save
			if @hasCalendar == false
				@calendar = Calendar.create!(:title => @user.family, :user_id => @user.id, :fam_id => @family.id)
			end
      flash[:notice] = "Account registered!"
      redirect_back_or_default account_url
    else
      render :action => :new
    end
  end
  
  def show
    @user = @current_user
		
		@presents_got = Reward.all(:conditions => ["user_id=? and finished=?", @user.id, true])
		@present = Reward.first(:conditions => ["user_id=? and finished=?", @user.id, false])
		stars_count = @user.entire_stars_count
		
		if !@present.nil?
			if !stars_count.nil?
				@presents_got.each{ |presents|
					stars_count -= presents.points
				}
				@stars_to_present = @present.points - stars_count
				if @stars_to_present >= @present.points
						@present.update_attributes(:finished => 1)
				end
			else 
				@stars_to_present = @present.points
			end
		end
  end
 
  def edit
    if @current_user.roles == "admin"
			@user = User.find(params[:id], :conditions => {:fam_id => @current_user.fam_id})
			@calendar = Calendar.first(params[:id], :conditions =>{:fam_id => @current_user.fam_id}) ## ist das dieselbe Zeile
		else
			@user = User.find(params[:id])
			@calendar = Calendar.first(:conditions =>{:fam_id => @current_user.fam_id}) ## ist das dieselbe Zeile
		end
		@colors= findcolors.merge!({@user.color => @user.color})
  end
	
	def findcolors
	  colors = {"green" => "green", "blue" => "blue", "pink" => "pink", "red" => "red"}
		@fam = @user.fam
		@users = @fam.users
		@users.each do |u|
			colors.delete(u.color)
		end
		return colors
	end
	
	def findcolor
		color = findcolors.values[0]
		return color
	end
  
  def update
    if @current_user.roles == "admin"
	    @user = User.find(params[:id], :conditions => {:fam_id => @current_user.fam_id})
		else
			@user = @current_user
		end
    if @user.update_attributes(params[:user])
      flash[:notice] = "Account updated!"
      redirect_to account_url
	 
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
		@event = Event.first(params[:event_id])
		
		@event.update_attributes(:finished => 1)
		
		flash[:notice] = "in here"
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
		@event.update_attributes(:finished => 1)
		
		flash[:notice] = "in here"
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
