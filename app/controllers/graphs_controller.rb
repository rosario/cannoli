
class GraphsController < ApplicationController


  # Graphs are created in this method
  def graph1


    p = Project.find(session[:project_id]) 
    @project = p


    # In the setup, the project was created with some random visitors
    # Here we decide, beginning and end of the time period
    bod = Time.parse("2009-01-01").strftime("%Y-%m-%d %H:%M:%S")
    eod = Time.parse("2009-01-15").end_of_day.strftime("%Y-%m-%d %H:%M:%S")

    vs = p.visitors.find(:all, :order => 'created_at', :conditions =>
    ["created_at > ? AND created_at < ?", "#{bod}", "#{eod}"])



    # We group visitors by created_at 
    list = vs.group_by do |e| 
      e.created_at.strftime("%Y/%m/%d")
      # This line can be used to get visitors per hour
      #e.created_at.strftime("%Y/%m/%d %H")
      
    end



    # We need to convert the created_at in a timestamp accepted by the flot library
    total_clicks =  []
    for l in list.keys
      total_clicks << "[#{Time.parse(l).to_i*1000}, #{list[l].size}]"
    end

    # This variable is going to be used in the view
    @total_clicks = "[#{total_clicks.join(",")}]"



    # Group the visitors by time_spent
    list = vs.group_by do |e|
      e.time_spent
    end

    @time_spent = "[[1,#{list["0:30 sec"].size}],[2,#{list["30:60 sec"].size}],[3,#{list["+60 sec"].size}]]"



    # Now group by browser_name
    list =vs.group_by do |e|  
      e.config_browser_name
    end
    

    @browsers =  "[[1,#{list["Other"].size}], 
                  [2,#{list["Firefox"].size }], 
                  [3,#{list["Opera"].size}], 
                  [4,#{list["Konqueror"].size}], 
                  [5,#{list["Safari"].size}], 
                  [6,#{list["MSIE"].size}], 
                  [7,#{list["Galeon"].size}], 
                  [8,#{list["Lynx"].size}], 
                  [9,#{list["Netscape"].size}]]"
 


  end


 
    
  
    
end
