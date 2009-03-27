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
      # Should I check for session[:project_id] first or always overwrite ? 
      project_id = params[:idsite]
      session[:project_id]  = project_id
      p = Project.find(project_id) 


      # If there's a session open, the visitor is known
      if session[:visitor_id]
        p "SESSION FOUND, VISITOR KNOWN"
        v = Visitor.find(session[:visitor_id])
      else
        p "NO SESSION"
        # There's no session, check if there was a visitor having the same browser configuration and IP today
        user_settings = Tracker.get_settings(params,request)  
        p "USER SETTINGS" + user_settings[:config_md5config]
        v = Visitor.here_today?(user_settings)
          
        # puts "#{v.nil?} or #{(Time.now - v.last_action_time) > 30.minutes}"
        if v.nil? 
          p "VISITOR NEW"
          # The visitor is new, create a new visitor and add him to the project
          v = Visitor.create_with_settings(user_settings)
          p.visitors << v
        elsif (Time.now - v.last_action_time) < 30.minutes
          p "VISITOR FOUND, but last action was 30 minutes ago"
          # The visitor was here, but more than 30 minutes ago, create a new visitor
           v = Visitor.create_with_settings(user_settings)
          p.visitors << v
        else
          # With no session, the visitor either cleared the cookies or restarted the browser...
          # I'll consider that as a returning visitor
            p "RETURNING VISITOR"
            v.was_here!
        
        end

        session[:visitor_id] = v.id
      end
      
     
      
      # Save the action only IF it's not already present.
      # Kind is used to distinguish between normal actions and goals
      # Other kinds should be used too, (such as downloads)
      
      action = Action.new(:url=>"#{params[:url]}", :url_id=> Digest::MD5.hexdigest(params[:url]),
                             :kind => params[:action_kind].to_i) 
    # Add the action to the project, only if it's new
    # Return the old action if present
     a = p.add_action(action)  

     v.add_action(a)
     
  end








  # THIS CODE IS NOT USED ANYMORE...


  # def log2
  #   project_id = params[:idsite]
  #   session[:project_id]  = project_id
  #   p = Project.find(project_id) 
  #   
  #   # Save the action
  #   # Kind is used to distinguish between normal actions and goals
  #   # Other kinds should be used too, (such as downloads)
  #   action = Action.create(:url=>"#{params[:url]}", :url_id=> Digest::MD5.hexdigest(params[:url]),
  #                          :kind => params[:action_kind].to_i)   
  #   
  #   
  #   # Check if the visitor has a session open
  #   if session[:visitor_id].nil?
  #     p "SESSION ID NOT FOUND"
  # 
  #     # There's no session, however we check if a visitor with the same settings
  #     # has already visited the website
  #     user_settings = Tracker.get_settings(params,request)           
  #     v = Visitor.here_today?(user_settings) # Check using user browser configuration + IP address
  #       
  #     if v.nil?
  #       p "VISITOR NEW TODAY"
  #       # There's no session id, and no visitor has been found. So we create a visitor
  #       v = Visitor.create_with_settings(user_settings)        
  #       p.visitors << v
  #     else
  #       p "VISITOR FOUND (he was here today)"
  #       v.was_here!
  #    
  #     end
  #   
  #     session[:visitor_id] = v.id
  #   else
  #     p "SESSION ID FOUND"
  #     v = Visitor.find(session[:visitor_id])
  #   end
  #   
  #   
  #  # v.actions << action
  #  v.add_action(action)
  #   
  # end
  #  

  


 
end
