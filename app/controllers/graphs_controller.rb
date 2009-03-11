
class GraphsController < ApplicationController

 
 


  # Graphs are created in this method
  def graph1


    p = Project.find(session[:project_id]) 
    
    @project = p
    
    @data = p.graph_data_between(:created_at_day, "2009-01-01", "2009-01-29")
        
    @data_bars = p.graph_data_between(:config_browser_name, "2009-01-01", "2009-01-29")
    
    @data_bars2 = p.graph_data_between(:config_os, "2009-01-01", "2009-01-29" )

  end


 
    
  
    
end
