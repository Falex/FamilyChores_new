require 'test_helper'

class RewardsControllerTest < ActionController::TestCase

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
			@calendar_1 = Calendar.create!(@calendar_params)
			
			@reward_params = {:title => "Tasche", :calendar_id => @calendar_1.id, :user_id => @user_1.id, :points => 20}
			@reward_1 = Reward.create!(@reward_params)
		end
		
		context "add reward" do
			setup do
			end
			should "increase Rewards.count" do
				assert_difference('Reward.count', 1) do
					post :create, :reward => {:title => "Kuchen", :calendar_id => @calendar_1.id, :user_id => @user_1.id, :points => 2}, 
					:calendar_id => @calendar_1.id
				end
				assert_redirected_to calendar_configurations_path(@calendar_1.id)
			end
		end
		
		context "GET to :edit" do
			setup do
				get :edit, :id => @reward_1.id, :calendar_id => @calendar_1.id
			end
			should_respond_with :success
		end
		
		context "update reward" do
			setup do
				put :update, :id => @reward_1.id, :reward => { }, :calendar_id => @calendar_1.id
			end
			should "redirect to calendar_configurations_path" do
				assert_redirected_to calendar_configurations_path(@calendar_1.id)
			end
		end
		
		context "destroy reward" do
			should "decrease Rewards.count" do
				assert_difference('Reward.count', -1) do
					delete :destroy, :id => @reward_1.id, :calendar_id => @calendar_1.id
				end
				assert_redirected_to calendar_configurations_path(@calendar_1.id)
			end
		end 
		
	end	
end
