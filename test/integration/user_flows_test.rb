require 'test_helper'

class UserFlowsTest < ActionController::IntegrationTest
  
	setup :activate_authlogic
	
	context 'A User' do
		setup do
			@family_params = {:id => 1, :title => "ich"}
			@family = Fam.create!(@family_params)
			@user_params = {:id => 1, :login => "claudi", :fam_id => @family.id, :family => "ich", :password => "123456", :email => "af@aon.at", :roles => "admin" }
			@user = User.new(@user_params)
			@user.save
			visit "account"
			assert_response :success
			fill_in "login", :with => "claudi"
			fill_in "password", :with => "123456"
			click_button
			assert_equal '/user_session', path
		end
		
		should 'be able to visit login section' do
			visit 'account'
			assert_response :success
		end
	end	
	
	context 'A User' do
		setup do
			@family_params = {:id => 1, :title => "ich"}
			@family = Fam.create!(@family_params)
			@user_params = {:id => 1, :login => "claudi", :fam_id => @family.id, :family => "ich", :family_password => "ich", :password => "123456", :email => "af@aon.at", :roles => "admin" }
			@user = User.new(@user_params)
			@user.save
			visit "account"
			assert_response :success
			fill_in "login", :with => "claudi"
			fill_in "password", :with => "123456"
			click_button 'Login'
			assert_equal @user.id, session["user_credentials_id"]
		end
		
		should 'be able to login with a valid email and password' do
			visit '/account'
			assert_response :success
		end
	end	
	
	context 'A logged in User' do
		setup do
			@family_params = {:id => 1, :title => "ich"}
			@family = Fam.create!(@family_params)
			@user_params = {:id => 1, :login => "claudi", :fam_id => @family.id, :family => "ich",:password => "123456", :color => "blue", :family_password => "ich", :password_confirmation =>"123456", :email => "af@aon.at", :roles => "admin" }
			@user = User.create!(@user_params)
			@calendar_params = {:id => 1, :title => "ich", :fam_id => @family.id, :user_id => @user.id}
			@calendar = Calendar.create!(@calendar_params)
			
			visit "account"
			assert_equal '/user_session/new', path
			assert_response :success
			fill_in "login", :with => "claudi"
			fill_in "password", :with => "123456"
			#fill_in "password_confirmation", :with => "123456"
			click_button 'Login'
			assert_equal 'Login successful!', flash[:notice]
			assert_equal @user.id, session["user_credentials_id"]
			assert_equal '/account', path
		end
		
		context 'from account path' do
			should 'be able to visit the rankings' do
				visit '/rankings'
				assert_response :success
			end
			should 'be able to visit the calendar' do
				visit '/calendars'
				assert_response :success
			end
		end
		
		context 'in edit account' do
			setup do
				visit '/account'
				click_link 'Edit Account', :user => @user, :calendar => @user.fam.calendar
				assert_equal "/users/#{@user.id}/edit", path 
			end
			should 'be able to change data' do
				fill_in "login",  "a@aont.at"
				fill_in "color", "green"
				click_button 'Update'
				assert_response :success
			end
		end
		
		context 'in calendar' do
			setup do
				visit '/account'
				click_link 'calendars'
				assert_equal "/calendars/#{@user.fam.calendar.id}", path
				@file = File.new(File.join(RAILS_ROOT, "/test/images/", "Blumen.png"))
				@chore_params_2 = {:id => 1, :title => "Staubsaugen", :calendar_id => @calendar.id, :image => @file}
				@chore_2 = Chore.create!(@chore_params_2)
			end
			should 'not be able to create chore' do
				fill_in "title", "am Gang"
				click_button 'Create'
				assert_equal "/calendars/#{@user.fam.calendar.id}/chores", path
			end
			should 'not be able to create event' do
				click_button 'Create'
				assert_equal "/calendars/#{@user.fam.calendar.id}/events", path
			end
		end
	end	
end
