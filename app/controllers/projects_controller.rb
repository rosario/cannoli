class ProjectsController < ApplicationController
  before_filter :authorize
  layout "projects", :except => [ :overview, :visitors,:referrers]
  
  

  def index
    
    @project = Project.find(session[:project_id])
       p = @project
       bod = Time.parse("2009-01-01").strftime("%Y-%m-%d %H:%M:%S")
        eod = Time.now.end_of_day.strftime("%Y-%m-%d %H:%M:%S")   
    
        conditions = ["created_at > ? AND created_at < ?", "#{bod}", "#{eod}"]
    
        vs = p.visitors.find(:all,:conditions=>conditions)
        @total_clicks = p.total_clicks(vs)
        
         @nvisits = vs.size
         @page_views =p.page_views(vs)
         if @page_views == 0
           @avg_pageviews = 0
         else
           @avg_pageviews = "%.2f" % ((@page_views+0.0)/@nvisits)
         end
         
         @time_on_site = p.time_on_site(vs)
         @bounce_rate = "%.2f" % (p.bounce_rate(vs) * 100)
         @new_visits = "%.2f" % (p.new_visits(vs) * 100)
         @data_website = p.website_list(vs).first(10)
         
        
    
  end
 

 def referrers
     p = Project.find(session[:project_id]) 
     @project = p
     bod = Time.parse("2009-01-01").strftime("%Y-%m-%d %H:%M:%S")
     eod = Time.now.end_of_day.strftime("%Y-%m-%d %H:%M:%S")   

     conditions = ["created_at > ? AND created_at < ?", "#{bod}", "#{eod}"]

     vs = p.visitors.find(:all,:conditions=>conditions)
      @data_website = p.website_list(vs)
      @searched_keywords =  p.search_engine_queries(vs)
     
     
  
 end
 
 def visitors
    p = Project.find(session[:project_id]) 
    @project = p
    bod = Time.parse("2009-01-01").strftime("%Y-%m-%d %H:%M:%S")
    eod = Time.now.end_of_day.strftime("%Y-%m-%d %H:%M:%S")   

    conditions = ["created_at > ? AND created_at < ?", "#{bod}", "#{eod}"]

    vs = p.visitors.find(:all,:conditions=>conditions)
   
   
   
         @config_os = p.config_os(vs)
         @browsers = p.browsers(vs)
         #@hours_by_servertime = p.hours_by_servertime(vs)
         @config_resolution = p.config_resolution(vs).first(5)
         @traffic_sources = p.traffic_sources(vs)
         
  
 end


   
end
