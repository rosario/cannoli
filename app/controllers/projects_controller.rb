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

  
  def setup
    
  end
  
  def create
    u = User.find(session[:user_id])
    project_name = params[:project_name]

    
    if u.project_id.nil?
      p = Project.create(:name=>project_name)
      u.project_id = p.id
      u.save
      
      # Randomly create 500 visitors. Useful for graphs generation
       500.times do 
         v = Visitor.create_random
              v.add_random_actions
              p.visitors << v
         end
          
     else
      p= Project.find(u.project_id)
    end
    session[:project_id]= p.id
    


    redirect_to project_overview_url(:id => p.id)
  end



   
end
