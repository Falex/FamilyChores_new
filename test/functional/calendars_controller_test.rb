require 'test_helper'

class CalendarsControllerTest < ActionController::TestCase

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
					get :index
			end
			should_respond_with :success
		end
		
		context "GET to :show" do
			setup do
				get :show, :id => @calendar.id
			end
			should_respond_with :success
		end
		
		context "GET to :edit" do
			setup do
				get :edit, :id => @calendar.id
			end
			should_respond_with :success
		end
		
		context "update calendar" do
			setup do
				put :update, :id => @calendar.id, :calendar => {:title => "test78", :description => "test78" }
			end
			should "redirect to calendar_path" do
				assert_redirected_to calendar_path
			end
		end
		
		context "destroy calendar" do
			should "decrease Calendar.count" do
				assert_difference('Calendar.count', -1) do
					delete :destroy, :id => @calendar.id
				end
				assert_redirected_to calendars_path
			end
		end  
	end

  context "a not logged in user" do
    setup do 
      get :index
	end
	should "be redirected to account" do
      assert_redirected_to account_url
    end
  end  

end