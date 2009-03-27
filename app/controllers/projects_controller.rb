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
      
      # Testing, add the actions
       urls = ["http://0.0.0.0:3000/website/page1",
                "http://0.0.0.0:3000/website/page2",
                "http://0.0.0.0:3000/website/page3",
                "http://0.0.0.0:3000/website/page4",
                "http://0.0.0.0:3000/website/page5"]
      as = []
      for u in urls
        p.add_action(Action.new(:url=>"#{u}", :url_id=> Digest::MD5.hexdigest(u), :kind => rand(2)))
      end
      
      
      # Randomly create 500 visitors. Useful for graphs generation
       500.times do 
         v = Visitor.create_random
              v.add_random_actions(p.actions)
              p.visitors << v
         end
         
       
          
     else
      p= Project.find(u.project_id)
    end
    session[:project_id]= p.id
    


    redirect_to project_overview_url(:id => p.id)
  end



   
end
