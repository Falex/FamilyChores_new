require 'test_helper'

class InteractWithRewardsTest < ActionController::IntegrationTest

	setup :activate_authlogic
	
	def login username, password
		fill_in "login", :with => username
		fill_in "password", :with => password
		click_button "Login"
		
		assert_equal '/account', path
	end
	
	def logout 
		click_link "Logout"
	end
	
	context 'A logged in user' do
	
		setup do
			@family =  Factory(:fam, :id => 1)
			@user = Factory(:user, :fam_id => @family.id, :password_confirmation => "123456", :roles => "admin")
			@user2 = Factory(:user, :login => "clara", :fam_id => @family.id, :password_confirmation => "123456", :roles => "child", :email => "clara@aon.at")
			@calendar = Factory(:calendar, :id => 1,:fam_id => @family.id, :user_id => @user.id)
			
			visit root_url
			assert_contain "Login"
		end
		
		context 'with role admin' do
			setup do
				login "claudi", "123456"
				
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
				
				should 'be not able to create rewards without a title' do
					select "claudi", :from => "reward_user_id"
					fill_in "reward_title", :with => ""
					click_button "reward_submit"
					
					assert_equal "/calendars/#{@calendar.id}/rewards", path
					assert_contain "Title is too short"
				end
				
				should 'be able to create rewards after correcting too short title' do
					select "claudi", :from => "reward_user_id"
					fill_in "reward_title", :with => ""
					click_button "reward_submit"
					
					fill_in "reward_title", :with => "Kinoticket"
					click_button "reward_submit"
					
					assert_equal "/calendars/#{@calendar.id}/configurations", path
					assert_contain "Kinoticket"
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
				
				should 'be able to delete a reward' do
					select "clara", :from => "reward_user_id"
					click_button "reward_submit"
					
					assert_contain "Buch deiner Wahl"
					click_link "Löschen"
					
					assert_not_contain "Buch deiner Wahl"
				end 
			end
			
			context 'on his/her own account page' do
				setup do
					visit "calendars/#{@calendar.id}/configurations"
					fill_in "reward_title", :with => "Buch deiner Wahl"
					select "5", :from => "reward_points"
					select "claudi", :from => "reward_user_id"
					click_button "reward_submit"
					
					assert_response :success
					visit "/account"
				end
				
				should 'be able to create rewards for himself/herself and see them on the page' do
					assert_contain "Buch deiner Wahl"
					assert_contain "claudi"
					assert_contain "5"
				end
				
				should 'be able to edit a reward and see changes on the page' do
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
				login "clara", "123456"
				
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
		
		context 'change rewards with admin, child' do
			setup do
				login "claudi", "123456"
				visit "calendars/#{@calendar.id}/configurations"
				fill_in "reward_title", :with => "Buch deiner Wahl"
				select "5", :from => "reward_points"
				select "clara", :from => "reward_user_id"
				click_button "reward_submit"
				logout
				login "clara", "123456"
				visit '/account'
			end
				
			should 'be able to view created reward' do
				assert_contain "Buch deiner Wahl"
				assert_contain "5"
			end
			
			should 'be able to see changes after reward has been edited by admin' do
				assert_contain "Buch deiner Wahl"
				assert_not_contain "60"
				assert_contain "5"
				logout
				login "claudi", "123456"
				
				visit "calendars/#{@calendar.id}/configurations"
				click_link "Bearbeiten"
				
				select "60", :from => "reward_points"
				click_button "Update"
				
				logout
				login "clara", "123456"
				
				visit "/account"
				assert_contain "60"
				assert_not_contain "5"
			end
			
			should 'not see reward after it has been deleted by admin' do
				assert_contain "Buch deiner Wahl"
				
				logout
				login "claudi", "123456"
				
				visit "calendars/#{@calendar.id}/configurations"
				click_link "Löschen"
				
				logout
				login "clara", "123456"
				
				visit "/account"
				assert_not_contain "Buch deiner Wahl"
			end 
		end
	end
end