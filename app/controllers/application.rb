# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery  :secret => '91316559316113309ae70eb9572fc84f'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  private 
  
    #Check if a user has logged in
    def authorize 
      unless User.find_by_id(session[:user_id]) 
        flash[:notice] = "Please log in" 
        redirect_to(:controller => "login", :action => "login") 
      end 
    end
    
    
    # The first user created is the admin
    def administrator
      unless session[:user_id] == 1
        flash[:notice] = "Restricted to admin only"
        redirect_to(:controller=>"login", :action =>"login")
      end
      
    end
end
