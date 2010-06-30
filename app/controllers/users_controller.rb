class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:show, :edit, :update]
  
  
  def new
    @user = User.new
  end
  
  def create

    
	#@family = Family.find(:all, :conditions => ["id=?", "1"])
	#@user = @family.users.build(params[:user])
	
	@user = User.new(params[:user])
	#@family = Family.find(:all, :conditions => ["title=?", @user.family])
	@family = Fam.find(:all, :conditions => ["title=?", @user.family])
	
	if @family.empty?
	   #@family = Family.new(:title => @user.family)
	   @family = Fam.new(:title => @user.family)
	   @family.save
	   @user.roles = "admin"
	else
	   @user.roles = "child"
	end
	
	@family = Fam.find(:all, :conditions => ["title=?", @user.family])
	
	#@user = @family.users.build(params[:user])
	#@family = Family.find(:all, :conditions => ["title=?", @user.family])
	
    @user.fam_id = @family[0].id 
	

	
    if @user.save
      flash[:notice] = @family[0].id #"Account registered!"
      redirect_back_or_default account_url
    else
      render :action => :new
    end
  end
  
  def show
    @user = @current_user
  end
 
  def edit
    if @current_user.roles == "admin"
	  @user = User.find(params[:id], :conditions => ["fam_id=?", @current_user.fam_id])
		@calendar = Calendar.first(params[:id], :conditions =>["fam_id=?", @current_user.fam_id])
		@colors= findcolors
    
		
	else
	  @user = User.find(params[:id])
		@calendar = Calendar.first(:conditions =>["fam_id=?", @current_user.fam_id])
    @colors= findcolors

 end
   
  end
	
	def findcolors
		colors=Hash.new
		if @calendar.green != true 
		colors = {"green" => "green"}
		end
		if @calendar.blue != true 
		colors.merge!({"blue" => "blue"})
		end
		if @calendar.pink != true 
		colors.merge!({"pink" => "pink"})
		end
		if @calendar.red != true 
		colors.merge!({"red" => "red"})
		end
		
		return colors
	end
  
  def update
    if @current_user.roles == "admin"
	   @user = User.find(params[:id], :conditions => ["fam_id=?", @current_user.fam_id])
		else
				@user = @current_user
		end
    if @user.update_attributes(params[:user])
			@calendar = Calendar.first(:conditions => ["fam_id=?", @current_user.fam_id])
			#color_used = (params[:user]).color
			#@calendar.update_attributes(:color_used => true)
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
		flash[:notice] = "in here"
	  if @user.entire_stars_count.nil?
		  new_count = 1;
	  else
		  new_count = @user.entire_stars_count + 1
	  end
	
		puts new_count

	  if @user.update_attributes(:entire_stars_count => new_count)
			flash[:notice] = "Added star"
	  end
		
		redirect_to calendar_url
	end
	
	def addCloud
	
	end
  

end
