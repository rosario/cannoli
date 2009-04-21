
class GraphsController < ApplicationController
  before_filter :authorize

 
 


  # Graphs are created in this method
  def graph1

    p = Project.find(session[:project_id]) 
    
    @project = p
    
    bod = Time.parse("2009-01-01").strftime("%Y-%m-%d %H:%M:%S")
    #eod = Time.parse("2009-01-29").end_of_day.strftime("%Y-%m-%d %H:%M:%S")   
    eod = Time.now.end_of_day.strftime("%Y-%m-%d %H:%M:%S")   
    
    conditions = ["created_at > ? AND created_at < ?", "#{bod}", "#{eod}"]

    vs = p.visitors.find(:all,:conditions=>conditions)
    
    # This data is used to show how to use the line_plot partial
    @example = [[0,0],[1,1],[2,2]]
    
    
    # @total_clicks = p.visitors.count(:id, 
    #           :group => 'strftime("%Y/%m/%d",created_at)', 
    #           :conditions => conditions)
    
    @total_clicks = vs.group_by { |v|
        v.created_at.strftime("%Y/%m/%d")
      }.map{|k,v|  [k,v.size]}.sort_by {|date,x| date}
          
    # @browsers = p.visitors.count(:id, 
    #              :group =>:config_browser_name,
    #              :conditions => conditions).sort_by{|x,y| y}.reverse
    # 
    
    @browsers =vs.group_by{|v| v.config_browser_name}.map{|k,v|  [k,v.size]}.sort_by{|x,y| y}.reverse.first(9)
    
    
    # @config_os = p.visitors.count(:id, 
    #                 :group =>:config_os,
    #                 :conditions => conditions).sort_by{|x,y| y}.reverse
    #   
    
    @config_os = vs.group_by{|v| v.config_os}.map{|k,v|  [k,v.size]}.sort_by{|x,y| y}.reverse.first(9)
    
    
    # @hours_by_servertime = p.visitors.count(:id, 
    #                 :group => 'strftime("%H",created_at)',
    #                 :conditions => conditions)
    
    @hours_by_servertime =vs.group_by{|v| v.created_at.strftime("%H")}.map{|k,v|  [k,v.size]}.sort_by {|date,x| date}
                    


    # @search_engines = p.visitors.count(:id, 
    #     :group => 'referer_name', 
    #     :conditions => ["referer_type = ? AND created_at > ? AND created_at < ?", "1", "#{bod}", "#{eod}"] ).sort_by{|x,y| y}.reverse
    
    @search_engines = vs.select{|v| v.referer_type == 1}.group_by{|v| v.referer_name}.map{|k,v| [k,v.size]}.sort_by{|x,y| y}.reverse
    
    
    
    @time_spent = vs.group_by {|v|v.time_spent_in_words }.map{|k,v|  [k,v.size]}.sort_by{|t,s| s}.reverse

    as = p.actions
    
    @actions = as.map{|a| [a.path,a.visitors.count(:group => :visitor_id).size]}.sort_by{|u,s| s}.reverse
   

  end


 
    
  
    
end
