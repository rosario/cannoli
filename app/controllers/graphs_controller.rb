
class GraphsController < ApplicationController

 
 


  # Graphs are created in this method
  def graph1

    p = Project.find(session[:project_id]) 
    
    @project = p
    
    bod = Time.parse("2009-01-01").strftime("%Y-%m-%d %H:%M:%S")
    eod = Time.parse("2009-01-29").end_of_day.strftime("%Y-%m-%d %H:%M:%S")
    
    conditions = ["referer_type = ? AND created_at > ? AND created_at < ?", "1", "#{bod}", "#{eod}"]
    
    # This data is used to show how to use the line_plot partial
    @example = [[0,0],[1,1],[2,2]]
    
    
    @total_clicks = p.visitors.count(:id, 
              :group => 'strftime("%Y/%m/%d",created_at)', 
              :conditions => conditions)
        
    @browsers = p.visitors.count(:id, 
                :group =>:config_browser_name,
                :conditions => conditions).sort_by{|x,y| y}.reverse
    
    @config_os = p.visitors.count(:id, 
                  :group =>:config_os,
                  :conditions => conditions).sort_by{|x,y| y}.reverse
    

    @hours_by_servertime = p.visitors.count(:id, 
                    :group => 'strftime("%H",created_at)',
                    :conditions => conditions)
                    
    @search_engines = p.visitors.count(:id, 
        :group => 'referer_name', 
        :conditions =>  ["referer_type = 1 
                          AND created_at > ? AND created_at < ? " , "#{bod}", "#{eod}"] ).sort_by{|x,y| y}.reverse
    # Need to be improved, see visitor.rb
    #@data_bars4 = p.visitors_count(:time_spent, "2009-01-01", "2009-01-29")

    
   

  end


 
    
  
    
end
