authorization do
	role :child do
	  has_permission_on :calendars, :to => [:index, :show]
	  has_permission_on :events, :to => [:index, :show, :new, :create]
	  has_permission_on :rankings, :to => [:index]
	  has_permission_on :events, :to => [:edit, :update, :destroy] do
	    if_attribute :user => is {user}
	  end
	end
	role :parent do
	  includes :child
		#has_permission_on :events, :to => [:sort]
	  has_permission_on [:events, :calendars, :chores], :to => [:index, :show, :new, :create, :edit, :update, :destroy]
		has_permission_on :users, :to => [:addStar, :addCloud]
	end
	
	role :admin do
	  includes :parent
	  has_permission_on :users, :to => [:destroy, :edit, :update]
	  has_permission_on :configurations, :to => [:index, :show, :update, :edit]
	end
end

