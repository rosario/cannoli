class LoginController < ApplicationController
  before_filter :authorize, :except =>  :login
  protect_from_forgery :except => :add_signup


  def login 
    session[:user_id] = nil 
    if request.post? 
      user = User.authenticate(params[:name], params[:password]) 
      if user 
        session[:user_id] = user.id
        
        if user.id == 1
            session[:admin] = 1
            redirect_to :controller =>'users', :action =>'list_users'
          else
            redirect_to :controller =>'dashboard', :action => 'index'

        end
        
    
      else 
        flash[:notice] = "Invalid user/password combination" 
      end 
    end 
  end 
 

  def logout 
    session[:user_id] = nil
    session[:project_id] = nil
    #session[:events_loaded] = nil
    flash[:notice] = "Logged out" 
    redirect_to(:action => "login") 
  end
  

  
  def index
  end

  def delete_user
  end
 
 

end
