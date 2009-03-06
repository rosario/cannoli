# Interface controller
class DashboardController < ApplicationController
   before_filter :authorize 
   
   
   # Redirect to projects/setup if the user hasn't got a project yet
   # otherwise redirect to projects/overview
   def index
     u = User.find(session[:user_id])
     pid = u.project_id
     if pid.nil?
       redirect_to :controller =>'projects', :action=> 'setup'
     else
       session[:project_id] = pid
       redirect_to project_overview_url(:id =>pid)
     end
     
   end
   
 

end

