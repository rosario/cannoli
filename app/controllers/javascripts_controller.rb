# Javascript code controller 

class JavascriptsController < ApplicationController


  # The main javascript tracker function, at the moment it's basically
  # taken from piwik.org. It registers the visitor informations and pass it
  # to log
  def piwik
  
    # see the views/javascripts/piwik.js.erb 
    
  end
  
 
  
  def clickmap
    if session[:user_id]
      a = Action.find(session[:action_id])
      
      name = a.url_id
      @heatmap = "#{SERVER_NAME}/images/#{name}.png"
      puts "HEATMAP >>>>>>>>>>>>>>>>>>" 
      puts @heatmap
      puts "ACTION ID <<<<<<<<<<<<<<"
      puts a.id.to_s
      
      @overlay_style = "<style type='text/css'>@import url('#{SERVER_NAME}/stylesheets/overlay.css');</style>"
      render :action => "overlay.js"
    else
      @click_url = "#{SERVER_NAME}/javascripts/click.js"
      render :action => "clickmap.js"
    end
       
    
  end

  # It keeps track of the visitor.
  # It is called from a visitor browser using the tracking javascript code
  
  
  def log
      
 
      
      if session[:user_id]
        # User (not the visitor) is logged in..we dont count his actions
        puts ">>>>>>>>>>>>>>>> USER LOGGED IN, ACTIONS not counted"
        
        
          # Questo mi serve per far funzionare la session[:action_id] dentro clickmap! 
          # Clean the URL from the last '/'
          url = params[:url]
          if url.last == "/"
            url.chop!
          end
          
          project_id = params[:idsite]
          p = Project.find(project_id)
          action = p.actions.find_by_url(url)
          session[:action_id] = action.id
        
        render :text => ""
      else
        
        project_id = params[:idsite]

        if (session[:project_id]) and (project_id != session[:project_id])
        # This visitor has already a session open, but using another project
          session[:visitor_id] = nil
        end

        session[:project_id] = project_id


        p = Project.find(project_id) 

        # Check if the params[:idsite] correspond to the right hostname
        # because we dont want to record stats from other hosts

        hostname = URI.parse(params[:url]).host
        if hostname.match(p.name) 
          puts " >>>>>>>>>>>>>>>>>> HOSTNAME MATCHES with the correct project_id"
          visitor_settings = Tracker.get_settings(params,request)  
          if session[:visitor_id]
            # Se c''e il visitor_id allora e' conosciuto
            # Vedo se l'ultima azione e' stata fatta in meno di mezzo'ora
            puts " >>>>>>>>>>>>>>>>> SESSION FOUND"
            v = Visitor.find(session[:visitor_id])
            if (Time.now - v.last_action_time) > 30.minutes
              # Sono passati piu' di 30 minuti, creo un nuovo visitor e lo metto come returning
              puts ">>>>>>>>>>>>>>>>>>>MORE THAN 30 minutes, create a new visitor"
              v = Visitor.create_with_settings(visitor_settings)
              p.visitors << v
              p.visitor_was_here!(v)
            end

          else

              puts ">>>>>>>>>>>>>>>>> NO SESSION"
              # There's no session, check if there was a visitor having the same browser configuration and IP today
              puts ">>>>>>>>>>> USER SETTINGS" + visitor_settings[:config_md5config]
              v = p.visitor_here_today?(visitor_settings)

              if v.nil? 
                puts ">>>>>>>>>>>> VISITOR NEW"
                # The visitor is new, create a new visitor and add him 
                v = Visitor.create_with_settings(visitor_settings)
                p.visitors << v
              else
                p ">>>>>>>>>>>> VISITOR HERE"

                if (Time.now - v.last_action_time) > 30.minutes
                  puts ">>>>>>>>>>>>>> MORE THAN 30 minutes, create new visitor"
                  # Sono passati piu' di 30 minuti, creo un nuovo visitor e lo metto come returning
                  v = Visitor.create_with_settings(visitor_settings)
                  p.visitors << v
                  p.visitor_was_here!(v)
                end

              end

          end

          session[:visitor_id] = v.id


          # Save the action only IF it's not already present.
          # Kind is used to distinguish between normal actions and goals
          # Other kinds should be used too, (such as downloads)

          # Clean the URL from the last '/'
          url = params[:url]
          if url.last == "/"
            url.chop!
          end

          action = Action.new(:url=>"#{url}", :url_id=> Digest::MD5.hexdigest(params[:url]),
                                   :kind => params[:action_kind].to_i) 
          # Add the action to the project, only if it's new
          # Return the old action if present
          a = p.add_action(action)  

          v.add_action(a)
          #session[:action_id] = action.id
          session[:action_id] = a.id
          puts "Setting ACTION ID = " + session[:action_id].to_s
          
        end
           
        
      end

  end


  def click
   
    # Note
    # a.visitors_clicking.find(:all, :group => :visitor_id), returns all visitors that have clicked
    # a.clicks.find(:all, :visitor_id), returns the clicks, with the different visitor_id counted only once.
    
    
    a = session[:action_id]
    v = session[:visitor_id]
    c = Click.create(:action_id => a, :visitor_id => v, :x => params[:x], :y => params[:y])
    
    render :text => ""
  end
 
 
end
