class UsersController < ApplicationController
  # After the first user is created (the administrator)
  # The lines below should be not commented
  
  #  before_filter :authorize
  #  before_filter :administrator
 
 def index
  
  @user = User.find(session[:user_id])
  
 end
 
 def list_users 
    @all_users = User.find(:all) 
  end
  
  def add_user
    @user = User.new(params[:user])
    if request.post? and @user.save
      flash.now[:notice] = "User #{@user.name} created"
      @user = User.new
    end
  end
  
  
end
