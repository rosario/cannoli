# Javascript code controller 

class JavascriptsController < ApplicationController



  # The main javascript tracker function, at the moment it's basically
  # taken from piwik.org. It registers the visitor informations and pass it
  # to log
  def piwik
  
    # see the views/javascripts/piwik.js.erb 
    
  end
  
  
  # It keeps track of the visitor.
  # It is called from a visitor browser using the tracking javascript code
  def log
    project_id = params[:idsite]
    session[:project_id]  = project_id
    p = Project.find(project_id) 
    
    # Save the action
    # Kind is used to distinguish between normal actions and goals
    # Other kinds should be used too, (such as downloads)
    action = Action.create(:url=>"#{params[:url]}", :url_id=> Digest::MD5.hexdigest(params[:url]),
                           :kind => params[:action_kind].to_i)   
    
    
    # Check if the visitor has a session open
    if session[:visitor_id].nil?
      p "SESSION ID NOT FOUND"

      # There's no session, however we check if a visitor with the same settings
      # has already visited the website
      user_settings = Tracker.get_settings(params,request)           
      v = Visitor.here_today?(user_settings) # Check using user browser configuration + IP address
        
      if v.nil?
        p "VISITOR NEW TODAY"
        # There's no session id, and no visitor has been found. So we create a visitor
        v = Visitor.create_with_settings(user_settings)        
        p.visitors << v
      else
        p "VISITOR FOUND (he was here today)"
     
      end
    
      session[:visitor_id] = v.id
    else
      p "SESSION ID FOUND"
      v = Visitor.find(session[:visitor_id])
    end
    
    
    v.actions << action
    
  end
 

  


 
end
