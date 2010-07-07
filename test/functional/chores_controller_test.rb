require 'test_helper'

class ChoresControllerTest < ActionController::TestCase

	setup :activate_authlogic
	
	 context "a logged in user" do
    setup do
			@family_params = {:id => 1, :title => "ich"}
			@family = Fam.create!(@family_params)

			@user_params = {:id => 1, :login => "susi", :fam_id => @family.id, :family => "ich", :password => "test", :email => "af@aon.at", :roles => "admin" }
			@user_1 = User.new(@user_params)
			@user_1.save
			UserSession.create(@user_1)
			
			@calendar_params = {:id => 1, :title => "ich", :fam_id => @family.id, :user_id => @user_1.id}
			@calendar = Calendar.create!(@calendar_params)
			
			@file = File.new(File.join(RAILS_ROOT, "/test/images/", "Blumen.png"))
			@chore_params_2 = {:id => 1, :title => "Staubsaugen", :calendar_id => @calendar.id, :image => @file}
			@chore_2 = Chore.create!(@chore_params_2)
			
		end
		
		context "GET to :index" do
			setup do
				@file = File.new(File.join(RAILS_ROOT, "/test/images/", "Blumen.png"))
				@chore_params = {:id => 1, :title => "Staubsaugen", :calendar_id => @calendar.id, :image => @file}
				@chore = Chore.create!(@chore_params)
				get :index, :calendar_id => @calendar.id
			end
			should_respond_with :success
		end
		
		context "GET to :new" do
			setup do
				get :new, :calendar_id => @calendar.id
			end
			should_respond_with :success
		end
		
		context "add chore" do
			setup do
				@file = File.new(File.join(RAILS_ROOT, "/test/images/", "Blumen.png"))
			end
			should "increase Chores.count" do
				assert_difference('Chore.count') do
					post :create, :chore => {:id => 1, :title => "Staubsaugen", :calendar_id => @calendar.id, :image => @file }, :calendar_id => @calendar.id
				end
				assert_redirected_to calendar_path(@calendar.id)
			end
		end
		
		context "GET to :edit" do
			setup do
				get :edit, :id => @chore_2.id, :calendar_id => @calendar.id
			end
			should_respond_with :success
		end
		
		context "update chore" do
			setup do
				put :update, :id => @chore_2.id, :chore => { }, :calendar_id => @calendar.id
			end
			should "redirect to calendar_configurations_path" do
				assert_redirected_to calendar_configurations_path(@calendar.id)
			end
		end
		
		context "destroy chore" do
			should "decrease Chore.count" do
				assert_difference('Chore.count', -1) do
					delete :destroy, :id => @chore_2.id, :calendar_id => @calendar.id
				end
				assert_redirected_to calendar_configurations_path(@calendar.id)
			end
		end  
	end
end


