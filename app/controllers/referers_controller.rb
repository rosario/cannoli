class ReferersController < ApplicationController
  before_filter :authorize
  layout "referers", :except => [:bello]
  


  def bello
       @project = Project.find(session[:project_id])
        @variabile = 1 

        p = @project


        bod = Time.parse("2009-01-01").strftime("%Y-%m-%d %H:%M:%S")
    #    eod = Time.parse("2009-01-29").end_of_day.strftime("%Y-%m-%d %H:%M:%S")
        eod = Time.now.end_of_day.strftime("%Y-%m-%d %H:%M:%S")

        conditions = ["referer_type = ? AND created_at > ? AND created_at < ? AND referer_keyword IS NOT NULL", 
                      "1", "#{bod}", "#{eod}"]



         # @queries = p.visitors.count(:id, 
         #                :group => 'referer_keyword', 
         #                :conditions => conditions).sort_by{|x,y| y}.reverse

        total_visits = p.visitors.find(:all, :conditions => conditions)

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

        @data = list.sort_by{|q,v,a,t| v}.reverse.first(25)
  
  
  end
  
  def queries
    @project = Project.find(session[:project_id])
    @variabile = 1 
    
    p = @project
  
    
    bod = Time.parse("2009-01-01").strftime("%Y-%m-%d %H:%M:%S")
#    eod = Time.parse("2009-01-29").end_of_day.strftime("%Y-%m-%d %H:%M:%S")
    eod = Time.now.end_of_day.strftime("%Y-%m-%d %H:%M:%S")
  
    conditions = ["referer_type = ? AND created_at > ? AND created_at < ? AND referer_keyword IS NOT NULL", 
                  "1", "#{bod}", "#{eod}"]
    
    
    
     # @queries = p.visitors.count(:id, 
     #                :group => 'referer_keyword', 
     #                :conditions => conditions).sort_by{|x,y| y}.reverse
                
    total_visits = p.visitors.find(:all, :conditions => conditions)
    
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
    
    @data = list.sort_by{|q,v,a,t| v}.reverse.first(25)
    
     ##################
     
     # Website
      conditions2 = ["referer_type = ? AND created_at > ? AND created_at < ? and referer_name NOT NULL", 
                     "3", "#{bod}", "#{eod}"]

      # p =Project.find(session[:project_id])
      
      
      total_visits = p.visitors.find(:all, :conditions => conditions2)
      
      
      
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
      
        @data2 = list.sort_by{|q,v,p,t| v}.reverse.first(25)
        
        #############
        
        # conditions3 = ["referer_type = ? AND created_at > ? AND created_at < ?", 
        #                         "2", "#{bod}", "#{eod}"]
        #  
        #                         total_visits = p.visitors.find(:all, :conditions => conditions3)
  
    
  end
  
end
