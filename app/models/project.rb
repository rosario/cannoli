# A project is associated with a website. ( A rename to Website should be done!)
class Project < ActiveRecord::Base
  has_many :users
  has_many :visitors
  
  
  # Get the visitors between two dates
  def visitors_between(date_begin, date_end)
    bod = Time.parse(date_begin).strftime("%Y-%m-%d %H:%M:%S")
    eod = Time.parse(date_end).end_of_day.strftime("%Y-%m-%d %H:%M:%S")
      
      
      
    vs = visitors.find(:all, :order => 'created_at', :conditions =>
      ["created_at > ? AND created_at < ?", "#{bod}", "#{eod}"])
      
    
  end
  
  def graph_data_between(name, date_begin,date_end)
    vs  = visitors_between(date_begin,date_end)
    list = vs.group_by do |e|
         e.send(name)
     end


     list.keys.map{|k| [k,list[k].size]}
    
  end
  
  
end
