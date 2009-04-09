class ProjectsController < ApplicationController
  before_filter :authorize
  

   
 
  def index
    redirect_to project_overview_url :id=>session[:project_id] 
  end
 
 def overview
   if session[:project_id] == nil
      @project = nil
    else
      @project = Project.find(session[:project_id])
    end
 end

  


   
end
