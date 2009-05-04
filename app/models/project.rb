# A project is associated with a website. ( A rename to Website should be done!)
class Project < ActiveRecord::Base
  has_many :users
  has_many :visitors
  has_many :actions
  
  
  
  def total_clicks(vs)
    vs.group_by { |v|
         v.created_at.strftime("%Y/%m/%d")
       }.map{|k,v|  [k,v.size]}.sort_by {|date,x| date}
  end
  
  
  def website_list(vs)
        total_visits = vs.select{|v| v.referer_type == 3 and (not v.referer_name.nil?)}
        queries = total_visits.group_by{|v| v.referer_name}

        list = []
        queries.keys.each do |k|
          vs = queries[k]
          nvisitors = queries[k].size

          total_actions = vs.inject(0){|total,v| total + v.total_actions}
          total_time = vs.inject(0){|total,v| total + v.time_spent}
          avg_time = (total_time/nvisitors).to_i
          avg_time = [avg_time/60 % 60, avg_time % 60].map{|t| t.to_s.rjust(2,'0')}.join(':')
          list << [k,
            nvisitors,
            "%.2f" % ((total_actions+0.0)/nvisitors),
            avg_time

          ]

        end

        ls = list.sort_by{|q,v,p,t| v}.reverse.first(25)
        return ls
        
  end
  
  
  def search_engine_queries(vs)
    
     total_visits = vs.select{|v| v.referer_type == 1 and (not v.referer_keyword.nil?)}
     queries = total_visits.group_by{|v| v.referer_keyword}

     list = []


     queries.keys.each do |k|
       vs = queries[k]
       nvisitors = queries[k].size

       total_actions = vs.inject(0){|total,v| total + v.total_actions}
       total_time = vs.inject(0){|total,v| total + v.time_spent}
       avg_time = (total_time/nvisitors).to_i
       avg_time = [avg_time/60 % 60, avg_time % 60].map{|t| t.to_s.rjust(2,'0')}.join(':')
       list << [k,
         nvisitors,
         "%.2f" % ((total_actions+0.0)/nvisitors),
         avg_time

       ]
       
       
       
     end
     ls = list.sort_by{|q,v,a,t| v}.reverse.first(25)
      
    return ls
  end
  
    def browsers(vs)
      vs.group_by{|v| v.config_browser_name}.map{|k,v|  [k,v.size]}.sort_by{|x,y| y}.reverse.first(9)
    end
    
    
    
    # @config_os = p.visitors.count(:id, 
    #                 :group =>:config_os,
    #                 :conditions => conditions).sort_by{|x,y| y}.reverse
    #   
    def config_os(vs)
      vs.group_by{|v| v.config_os}.map{|k,v|  [k,v.size]}.sort_by{|x,y| y}.reverse.first(9)
    end
    
    def config_resolution(vs)
      vs.group_by{|v| v.config_resolution}.map{|k,v|  [k,v.size]}.sort_by{|x,y| y}.reverse.first(9)
      
    end  
    
    
    
    # @hours_by_servertime = p.visitors.count(:id, 
    #                 :group => 'strftime("%H",created_at)',
    #                 :conditions => conditions)    
    def hours_by_servertime(vs)
      vs.group_by{|v| v.created_at.strftime("%H")}.map{|k,v|  [k,v.size]}.sort_by {|date,x| date}
    end
    
                    
    def traffic_sources(vs)
      ref_type = []
      ref_type[0] = "Campaign"
      ref_type[1] = "Search engine"
      ref_type[2] = "Direct entry"
      ref_type[3] = "Referring sites"
      
      size = vs.size
      vs.group_by{|v| v.referer_type}.map{|k,v| [k,v.size]}.sort_by{|x,y| y}.reverse.map{|k,v| [ref_type[k], "%.2f" % (((v+0.0)/size)*100)]}
        
      
    end

    # @search_engines = p.visitors.count(:id, 
    #     :group => 'referer_name', 
    #     :conditions => ["referer_type = ? AND created_at > ? AND created_at < ?", "1", "#{bod}", "#{eod}"] ).sort_by{|x,y| y}.reverse
    def search_engines(vs)
      vs.select{|v| v.referer_type == 1}.group_by{|v| v.referer_name}.map{|k,v| [k,v.size]}.sort_by{|x,y| y}.reverse
    end

    
    def time_spent(vs)  
      vs.group_by {|v|v.time_spent_in_words }.map{|k,v|  [k,v.size]}.sort_by{|t,s| s}.reverse
    end
    
    def time_on_site(vs)
      if vs.size == 0
        return 0
      else
        secs =vs.inject(0){|sum,v|  sum  + v.time_spent.to_i}
        secs = (secs)/vs.size
        return [ secs/3600, secs / 60, secs  % 60 ].map{ |t| t.to_s.rjust(2, '0') }.join(':')
        #return secs
      end
      
      
    end
    
    def visitors_per_action
      as = self.actions
      as.map{|a| [a.path,a.visitors.count(:group => :visitor_id).size]}.sort_by{|u,s| s}.reverse
    end
    
    def bounce_rate(vs)
      if vs.size == 0 
        return 0
      else
        one_page_visitors = vs.select{|v| v.actions.size == 1}.size
        return (one_page_visitors+0.0)/vs.size
      end
      
    end
  
    def new_visits(vs)
      if vs.size == 0
        return 0
      else
        new_ones = vs.select{|v| v.was_here == 0}.size
        return (new_ones+0.0)/vs.size
      end
      
    end
    
    def page_views(vs)
      if vs.size == 0
        return 0 
      else
        pages = vs.inject(0){|sum,v| sum + v.actions.size}  
      end
      
    end
    
    
  
 # Check if a visitor in this project was here today
  def visitor_here_today?(user_settings)
     md5config = user_settings[:config_md5config]
     p "MD5 ==>" + user_settings[:config_md5config]


     v = self.visitors.find(:first, 
       :conditions => ["created_at > '#{1.day.ago}' AND config_md5config = '#{md5config}'"])
     return v

   end

  


   # Set the was_here flag
   def visitor_was_here!(v)
     if v.was_here.nil?
       v.was_here = 1
     else
       v.was_here = v.was_here + 1
     end
     v.save

   end
  
  
  
  # Add an action to the project, only if it's new
  def add_action(action)
    a = self.actions.find_by_url(action.url)
    if a.nil? 
      a = action
      actions << a
    end
    return a
  end
  
  # Get the visitors between two dates
  def visitors_between(date_begin, date_end)
    bod = Time.parse(date_begin).strftime("%Y-%m-%d %H:%M:%S")
    eod = Time.parse(date_end).end_of_day.strftime("%Y-%m-%d %H:%M:%S")
      
      
      
    vs = visitors.find(:all, :order => 'created_at', :conditions =>
      ["created_at > ? AND created_at < ?", "#{bod}", "#{eod}"])
      
    
  end
  
  
  # Note, depending on the DB, it could be more efficient to 
  # use a different approach: example, 
  # p.visitors.count(:id, :group => :config_os) or
  # p.visitors.count(:id, :group => 'strftime("%Y:%m:%d",created_at)')
  # At the moment is used to group visitors by the time_spent (which is a method in the Visitor class)
 
  def visitors_count(name, date_begin, date_end)
    
    vs = visitors_between(date_begin, date_end)
    hash = vs.group_by{|v| v.send(name)}
    list = hash.keys.map{|k| [k,hash[k].size]}
        
  end
  
  
end
