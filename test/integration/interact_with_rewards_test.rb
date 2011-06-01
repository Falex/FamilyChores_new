require 'test_helper'

class InteractWithRewardsTest < ActionController::IntegrationTest

	setup :activate_authlogic
	
	context 'A logged in user' do
	
		setup do
			@family =  Factory.build(:fam, :id => 1)
			@family.save
			@user = Factory.build(:user, :fam_id => @family.id, :password_confirmation => "123456", :roles => "admin")
			@user.save
			@calendar = Factory.build(:calendar, :id => 1,:fam_id => @family.id, :user_id => @user.id)
			@calendar.save
			@user2 = Factory.build(:user, :login => "clara", :fam_id => @family.id, :password_confirmation => "123456", :roles => "child", :email => "clara@aon.at")
			@user2.save
			visit root_url
			assert_contain "Login"
		end
		
		context 'with role admin' do
			setup do
				fill_in "login", :with => "claudi"
				fill_in "password", :with => "123456"
				click_button "Login"
				assert_equal '/account', path
			end
			
			should 'be able to visit configurations page and see Belohnungen(rewards)' do
				visit "calendars/#{@calendar.id}/configurations"
				assert_response :success
				assert_contain "Belohnungen"
			end
			
			context 'on configurations page' do
				setup do
					visit "calendars/#{@calendar.id}/configurations"
					fill_in "reward_title", :with => "Buch deiner Wahl"
					select "10", :from => "reward_points"
				end
				
				should 'be able to create rewards for himself/herself and see them on the configurations page' do
					select "claudi", :from => "reward_user_id"
					click_button "reward_submit"
					assert_response :success
					assert_contain "Buch deiner Wahl"
					assert_contain "claudi"
					assert_contain "10"
				end
				
				should 'be able to create rewards for others and see them on the configurations page' do
					select "clara", :from => "reward_user_id"
					click_button "reward_submit"
					assert_response :success
					assert_contain "Buch deiner Wahl"
					assert_contain "clara"
					assert_contain "10"
				end
				
				should 'be able to edit a reward and see changes on configurations page' do
					select "clara", :from => "reward_user_id"
					click_button "reward_submit"
					assert_contain "Buch deiner Wahl"
					assert_contain "10"
					reward = Reward.find_by_title("Buch deiner Wahl")
					click_link "Bearbeiten"
					assert_equal "/calendars/#{@calendar.id}/rewards/#{reward.id}/edit", path
					select "60", :from => "reward_points"
					click_button "Update"
					assert_equal "/calendars/#{@calendar.id}/configurations", path
					assert_contain "60"
				end
				
				should 'be able to delete a reward and dont find its title on configurations page anymore' do
					select "clara", :from => "reward_user_id"
					click_button "reward_submit"
					assert_contain "Buch deiner Wahl"
					click_link "Löschen"
					assert_not_contain "Buch deiner Wahl"
				end 
			end
			
			context 'on his/her account' do
				setup do
					visit "calendars/#{@calendar.id}/configurations"
					fill_in "reward_title", :with => "Buch deiner Wahl"
					select "5", :from => "reward_points"
					select "claudi", :from => "reward_user_id"
					click_button "reward_submit"
					assert_response :success
					visit "/account"
				end
				
				should 'be able to create rewards for himself/herself and see them on the configurations page' do
					assert_contain "Buch deiner Wahl"
					assert_contain "claudi"
					assert_contain "5"
				end
				
				should 'be able to edit a reward and see changes on account page' do
					assert_contain "Buch deiner Wahl"
					assert_not_contain "60"
					assert_contain "5"
					reward = Reward.find_by_title("Buch deiner Wahl")
					visit "calendars/#{@calendar.id}/configurations"
					click_link "Bearbeiten"
					select "60", :from => "reward_points"
					click_button "Update"
					visit "/account"
					assert_contain "60"
					assert_not_contain "5"
				end
				
				should 'be able to delete a reward and dont find its title on account page anymore' do
					assert_contain "Buch deiner Wahl"
					visit "calendars/#{@calendar.id}/configurations"
					click_link "Löschen"
					visit "/account"
					assert_not_contain "Buch deiner Wahl"
				end 
			end
			
			context 'on his/her account page when he/she hasnt got any points yet' do
				setup do 
					visit "calendars/#{@calendar.id}/configurations"
					fill_in "reward_title", :with => "Konzert Ticket"
					select "30", :from => "reward_points"
					select "clara", :from => "reward_user_id"
					click_button "reward_submit"
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
					assert_not_contain "Konzert Ticket"
					assert_not_contain "30"
					assert_not_contain "Gesammelte Sterne"
				end
			end
			
			#context 'give points for well done chore' do
			#	setup do
			#		visit "/calendars/#{@calendar.id}"
			#		assert_equal "/calendars/#{@calendar.id}", path
			#		chore = stub_everything(:calendar_id => @calendar.id, :title => "Staubwischen")
			#		event = Factory(:event, :calendar_id => @calendar.id, :chore_id => chore.id, :start_on => Date.today, :user_id => @user.id)
			#	end
				
			#	should 'be able to give points' do
			#		click_link "AddStar"
			#	end
			#end
			
			context 'on his/her account page when he/she has got some points' do
				setup do 
					visit "calendars/#{@calendar.id}/configurations"
					fill_in "reward_title", :with => "Konzert Ticket"
					select "30", :from => "reward_points"
				
					@user.entire_stars_count = 10
					@user.save
				end
				
				should 'be able to see how many points he/she has got already' do
					assert_contain "10"
				end
				
				should 'be able to see his next reward if one is already created for him/her' do
				  select "claudi", :from => "reward_user_id"
					click_button "reward_submit"
					visit "/account"
					assert_equal "/account", path
					assert_contain "Konzert Ticket"
					assert_contain "10/30"
					assert_contain "Gesammelte Sterne"
				end
				
				should 'not be able to see his next reward if none is yet created for him/her' do
					select "clara", :from => "reward_user_id"
					click_button "reward_submit"
					visit "/account"
					assert_not_contain "Konzert Ticket"
					assert_not_contain "30"
					assert_not_contain "Gesammelte Sterne"
				end	
			end
		end	
		
		context 'with role child' do
			setup do
				fill_in "login", :with => "clara"
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
			
			should 'be able to see reward created first when not yet finished' do
				reward1 = Factory(:reward, :user_id => @user2.id, :calendar_id => @calendar.id)
				reward2 = Factory(:reward, :user_id => @user2.id, :calendar_id => @calendar.id, :title => "Neue Hose")
				visit "/account"
				assert_contain "Konzert Ticket"
				assert_not_contain "Neue Hose"
			end
			
			should 'be able to see second reward when first already finished' do
				reward1 = Factory(:reward, :user_id => @user2.id, :calendar_id => @calendar.id, :finished => true)
				@user2.entire_stars_count = 61
				@user2.save
				reward2 = Factory(:reward, :user_id => @user2.id, :calendar_id => @calendar.id, :title => "Neue Hose", :points => 10)
				visit "/account"
				assert_not_contain "Konzert Ticket"
				assert_contain "Neue Hose" 
				assert_contain "1/10"
			end
			
			should 'not be able to see first award when first when its finished and no other created yet' do
				reward1 = Factory(:reward, :user_id => @user2.id, :calendar_id => @calendar.id, :finished => true)
				@user2.entire_stars_count = 61
				@user2.save
				visit "/account"
				assert_not_contain "Konzert Ticket"
				assert_not_contain "Gesammelte Sterne"
				assert_contain "61"
			end
		end
	end
end