# A project is associated with a website. ( A rename to Website should be done!)
class Project < ActiveRecord::Base
  has_many :users
  has_many :visitors
  has_many :actions
  
  
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
