require 'test_helper'

class ConfigurationsControllerTest < ActionController::TestCase
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
		end
		
		context "GET to :index" do
			setup do
					get :index, :calendar_id => @calendar.id
			end
			should_respond_with :success
		end
	end	
end
