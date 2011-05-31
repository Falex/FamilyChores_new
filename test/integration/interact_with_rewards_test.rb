require 'test_helper'

class InteractWithRewardsTest < ActionController::IntegrationTest

	setup :activate_authlogic
	
	context 'A logged in user with role admin' do
		setup do
			@family =  Factory.build(:fam, :id => 1)
			@family.save
			@user = Factory.build(:user, :fam_id => @family.id, :password_confirmation => "123456", :roles => "admin")
			@user.save
			@calendar = Factory.build(:calendar, :id => 1,:fam_id => @family.id, :user_id => @user.id)
			@calendar.save
			@user3 = Factory.build(:user, :login => "clara", :fam_id => @family.id, :password_confirmation => "123456", :roles => "child", :email => "clara@aon.at")
			@user3.save
			visit root_url
			assert_contain "Login"
			fill_in "login", :with => "claudi"
			fill_in "password", :with => "123456"
			click_button "Login"
			assert_equal '/account', path
		end
		
		should 'be able to visit configurations page and see Belohnungen/rewards' do
			visit "calendars/#{@calendar.id}/configurations"
			assert_response :success
			assert_contain "Belohnungen"
		end
		
		context 'on configurations page' do
			setup do
				visit "calendars/#{@calendar.id}/configurations"
			end
			
			should 'be able to create rewards for himself/herself' do
				fill_in "reward_title", :with => "Buch deiner Wahl"
				select "10", :from => "reward_points"
				select "claudi", :from => "reward_user_id"
				click_button "reward_submit"
				assert_response :success
				assert_contain "Buch deiner Wahl"
				assert_contain "claudi"
				assert_contain "10"
			end
			
			should 'be able to create rewards for others' do
				fill_in "reward_title", :with => "Kinoticket"
				select "5", :from => "reward_points"
				select "clara", :from => "reward_user_id"
				click_button "reward_submit"
				assert_response :success
				assert_contain "Kinoticket"
				assert_contain "clara"
				assert_contain "5"
			end
			
			should 'be able to edit a reward' do
				reward = Factory(:reward, :user_id => @user.id, :calendar_id => @calendar.id)
				reload
				assert_contain "Konzert Ticket"
				click_link "Bearbeiten"
				assert_equal "/calendars/#{@calendar.id}/rewards/#{reward.id}/edit", path
				select "60", :from => "reward_points"
				click_button "Update"
				assert_equal "/calendars/#{@calendar.id}/configurations", path
				assert_contain "60"
			end
			
			should 'be able to delete a reward' do
				reward = Factory(:reward, :user_id => @user.id, :calendar_id => @calendar.id)
				reload
				assert_contain "Konzert Ticket"
				click_link "Löschen"
				assert_not_contain "Konzert Ticket"
			end 
		end
		
		context 'on his/her account page when he/she hasnt got any points yet' do
			setup do 
				visit "/account"
				assert_equal "/account", path
			end
			
			should 'be able to see his next reward if one is already created for him/her' do
				reward = Factory(:reward, :user_id => @user.id, :calendar_id => @calendar.id)
				reload
				assert_contain "Konzert Ticket"
				assert_contain "0/30"
				assert_contain "Gesammelte Sterne"
			end
			
			should 'not be able to see his next reward if none is yet created for him/her' do
				reward = Factory(:reward, :user_id => @user3.id, :calendar_id => @calendar.id)
				reload
				assert_not_contain "Konzert Ticket"
				assert_not_contain "30"
				assert_not_contain "Gesammelte Sterne"
			end
		end
		
		context 'give points for well done chore' do
			setup do
				visit "/calendars/#{@calendar.id}"
				assert_equal "/calendars/#{@calendar.id}", path
			end
			
			#chore = Factory(:chore, :calendar_id => , :image => )
			#event = Factory(:event, :calendar_id => @calendar.id, :chore_id => 1, :start_on => Date.today)
			#click_link "Stern_bewertung_inaktiv"
		end
		
		context 'on his/her account page when he/she has got some points' do
			setup do 
				visit "/account"
				assert_equal "/account", path
				@user.entire_stars_count = 10
				@user.save
			end
			
			should 'be able to see how many points he/she has got already' do
				assert_contain "10"
			end
			
			should 'be able to see his next reward if one is already created for him/her' do
				reward = Factory(:reward, :user_id => @user.id, :calendar_id => @calendar.id)
				reload
				assert_contain "Konzert Ticket"
				assert_contain "10/30"
				assert_contain "Gesammelte Sterne"
			end
			
			should 'not be able to see his next reward if none is yet created for him/her' do
				reward = Factory(:reward, :user_id => @user3.id, :calendar_id => @calendar.id)
				reload
				assert_not_contain "Konzert Ticket"
				assert_not_contain "30"
				assert_not_contain "Gesammelte Sterne"
			end	
		end
	end	
	
	context 'A logged in user with role child' do
		setup do
			@family =  Factory.build(:fam, :id => 1)
			@family.save
			@user = Factory.build(:user, :fam_id => @family.id, :password_confirmation => "123456", :roles => "child")
			@user.save
			@user2 = Factory.build(:user, :login => "hans", :fam_id => @family.id, :password_confirmation => "123456", :roles => "child", :email => "hans@aon.at")
			@user2.save
			@calendar = Factory.build(:calendar, :id => 1,:fam_id => @family.id, :user_id => @user.id)
			@calendar.save
			visit root_url
			assert_contain "Login"
			fill_in "login", :with => "hans"
			fill_in "password", :with => "123456"
			click_button "Login"
			assert_equal '/account', path
		end
		
		should 'be not able to visit configurations page and see Belohnungen/rewards' do
			visit "calendars/#{@calendar.id}/configurations"
			assert_response :forbidden
			assert_contain "You are not allowed to access this action"
		end
		
		should 'not be able to edit a reward' do
			reward = Factory(:reward, :user_id => @user.id, :calendar_id => @calendar.id)
			visit "/calendars/#{@calendar.id}/rewards/#{reward.id}/edit"
			assert_response :forbidden
			assert_contain "You are not allowed to access this action"
		end
	end
end