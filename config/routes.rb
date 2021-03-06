ActionController::Routing::Routes.draw do |map|
  map.resources :rewards

  map.resources :fams, :has_many => :users
  #map.resources :fams, :has_many => :calendars

  map.resources :families
  map.resources :calendars, :has_many => :configurations #, :has_many => :users
  map.resources :chores
  
	map.resources :calendars, :has_many => :rankings
	
	map.resources :calendars do |calendar|
    calendar.resources :configurations
  end
	
	#map.resources :icalfiles #, :collection => {:download => :get}  #do |icalfile|
	#	icalfile.resources :users
	#end
	map.resources :users do |user|
		user.resources :icalfiles, :collection => {:download => :get}
	end
	
	map.resources :icalfiles, :collection => {:download => :get}
	
	map.resources :calendars do |calendar|
    calendar.resources :rewards
		#calendar.resources :icalfiles
		calendar.resources :events, :collection => {:sort => :post}
  end

  
  map.root :controller => 'user_sessions', :action => 'new' 
  #map.resources :calendars, :has_many => users
  #map.resources :families, :has_many => :users
  map.resources :calendars, :has_many => :chores
  map.resources :calendars, :has_many => :events
  map.resources :calendars, :has_many => :rewards
  map.resource :account, :controller => 'users'
	 
  map.resources :users
  map.resource :user_session
	
	

  #map.resource :chorescalendar, :controller => 'icalfiles'
	#map.connect ':icalfiles/:index/:id.:format'

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
