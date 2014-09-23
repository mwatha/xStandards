XStandards::Application.routes.draw do


  ###### properties #####
  #get "property/index"
  match '/properties' => 'property#index'
  ###### properties end #####

  ###### transporter #####
  match '/transporters' => 'transporter#index'
  match '/newtransporter' => 'transporter#new'
  match '/findtransporter' => 'transporter#search'
  post 'transporter/create'
  ###### transporter end #####

  ###### countries #####
  match '/countries' => 'country#index'
  match '/findcountries' => 'country#findcountries'
  match '/findborders' => 'country#findborders'
  match '/findmarkets' => 'country#findmarkets'
  match '/viewcounties' => 'country#finddistricts'
  match '/newcountry' => 'country#newcountry'
  match '/newborder' => 'country#newborder'
  match '/newmarket' => 'country#newmarket'
  match '/newdistrict' => 'country#newdistrict'

  post 'country/createcountry'
  post 'country/createborder'
  post 'country/createmarket'
  post 'country/createdistrict'

  post "country/create_sub_county"
  match '/sub_county' => 'country#sub_county'
  ###### countries end #####

  ###### reports #####
  match '/reports' => 'report#index'
  match '/production' => 'report#production'
  match '/line_graph' => 'report#line_graph'
  get 'report/production_pie_chart'
  get 'report/production_line_chart'
  match 'market' => "report#market"
  match 'indu' => "report#industry"


  post "report/production_charts"
  post "report/industry_charts"
  post "report/market_charts"
  match 'production_charts' => "report#production_charts"
  match 'market_charts' => "report#market_charts"
  match 'industry_charts' => "report#industry_charts"

  match 'market' => "report#market"

  ###### reports end #####

  ###### product #####
  match '/searchproduct' => 'product#search'
  match '/newproduct' => 'product#new'
  post "product/create"
  match 'product_details/:id' => 'product#show', :as => :product_details
  ###### product end #####

  ###### manufacturer #####
  match '/searchmanufacturer' => 'manufacturer#search'
  match '/newmanufacturer' => 'manufacturer#new'
  match '/manufacturer' => "manufacturer#index"
  match 'manufacturer_details/:id' => 'manufacturer#show', :as => :manufacturer_details
  post "manufacturer/create"                                                             
  ###### manufacturer end #####

  ###### sample #####
  match '/sample' => 'sample#index'
  match '/newsample' => 'sample#new'
  match '/searchsample' => 'sample#search'
  post "sample/create"                                                             
  get 'sample/update_products'
  match '/sampling' => 'sample#sampling'
  get 'sample/update_districts'
  get 'sample/update_markets'
  get 'sample/update_borders'

  post "sample/create_market_raw_data"                                                             
  post "sample/create_quality_monitoring_raw_data"                                                             

  match 'raw_data_quality_monitoring' => 'sample#raw_data_quality_monitoring'
  match "find_raw_data_industry_monitoring" => "sample#find_raw_data_industry_monitoring"
  match "find_raw_data_market_control" => "sample#find_raw_data_market_control"
  match "import_monitoring" => "sample#import_monitoring"

  match 'industry' => "sample#industry"
  match 'prod' => "sample#production"
  match 'mark' => "sample#market"

  match 'import_datagrid' => "sample#import_datagrid"
  match 'create_quality_monitoring_raw_data' => 'sample#create_quality_monitoring_raw_data'
  match 'update_quality_monitoring_raw_data' => 'sample#update_quality_monitoring_raw_data'

  match 'industry_datagrid' => "sample#industry_datagrid"
  match 'raw_data_industry_create' => 'sample#raw_data_industry_create'
  match 'update_industry_datagrid' => 'sample#update_industry_datagrid'


  match 'market_datagrid' => "sample#market_datagrid"
  match 'raw_data_market_create' => "sample#raw_data_market_create"                                                             
  match 'raw_data_market_update' => "sample#raw_data_market_update"                                                             
  #get "sample/market_datagrid"
  match 'delete_entered_data/:id/:cmd' => 'sample#delete_entered_data', :as => :delete_entered_data


  match 'edit_industry/:id' => 'sample#edit_industry', :as => :edit_industry
  post "sample/edit_industry"                                                             

  match 'edit_import/:id' => 'sample#edit_import', :as => :edit_import
  post "sample/edit_import"                                                             

  match 'edit_market/:id' => 'sample#edit_market', :as => :edit_market
  post "sample/edit_market"                                                             
  ###### sample end #####

  ###### user #######
  #get "user/logout"                                                             
  #post "user/login"
  #match '/login' => 'user#login'
  #match 'settings/:id' => 'user#index', :as => :settings

  match 'login' => 'user#login'
  get "user/logout"
  post "user/login"
  match 'edit_user/:id' => 'user#edit', :as => :edit_user
  post "user/update"
  match 'settings/:id' => 'user#index', :as => :settings
  match 'new_user' => 'user#new'
  post 'user/create'
  match 'remove_user/:id' => 'user#delete', :as => :remove_user
  match 'assign_role/:id' => 'user#roles', :as => :assign_role
  post 'user/assign_role'
  match '/username_availability' => 'user#username_availability'
  match 'details/:id' => 'user#show', :as => :details
  match 'assign_role' => 'user#assign_role'
  ###### user end #######

  ###### home #######
  match '/home' => 'home#index'
  ###### home end #######





  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
  get "home/index"

  root :to => 'user#login'
end
