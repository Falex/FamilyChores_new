class ChoresController < ApplicationController
	before_filter :load_calendar
  filter_resource_access
	
	# GET /chores
  # GET /chores.xml
  def index
    @chores = @calendar.chores

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @chores }
    end
  end

  # GET /chores/1
  # GET /chores/1.xml
  def show
    @chore = Chore.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @chore }
    end
  end

  # GET /chores/new
  # GET /chores/new.xml
  def new
    @chore = Chore.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @chore }
    end
  end

  # GET /chores/1/edit
  def edit
    @chore = Chore.find(params[:id])
  end

  # POST /chores
  # POST /chores.xml
  def create
    @calendar = Calendar.find(params[:calendar_id])
    @chore = @calendar.chores.build(params[:chore])

    respond_to do |format|
      if @chore.save
        flash[:notice] = 'Chore was successfully created.'
        format.html { redirect_to(@calendar) }
        format.xml  { render :xml => @chore, :status => :created, :location => @chore }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @chore.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /chores/1
  # PUT /chores/1.xml
  def update
    @chore = Chore.find(params[:id])

    respond_to do |format|
      if @chore.update_attributes(params[:chore])
        flash[:notice] = 'Chore was successfully updated.'
        format.html { redirect_to calendar_configurations_path(params[:calendar_id]) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @chore.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /chores/1
  # DELETE /chores/1.xml
  def destroy
    @chore = Chore.find(params[:id])
    @chore.destroy

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
end
