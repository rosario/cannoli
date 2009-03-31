# An Action represent the page the visitor requested
class Action < ActiveRecord::Base
 # belongs_to :visitor
  belongs_to :project
  has_many :visits
  has_many :visitors, :through => :visits
  
  require 'uri'
  
 
  # Non uso piu URI.split ma URI.parse

     # URI.split("http://www.site.com:8080/controller/action/var/var2?p=2&c=3")
     # => ["http", nil, "www.site.com", "8080", nil, "/controller/action/var/var2", nil, "p=2&c=3", nil]
     
      # * Scheme
      # * Userinfo
      # * Host
      # * Port
      # * Registry
      # * Path
      # * Opaque
      # * Query
      # * Fragment
        
   
 
    
    
  def query
    URI.split(url)[7]
  end
  
  def path
    URI.split(url)[5]
  end
  
  def url_id
    
  end
  
  def self.new_random
    urls = ["http://0.0.0.0:3000/website/page1",
            "http://0.0.0.0:3000/website/page2",
            "http://0.0.0.0:3000/website/page3",
            "http://0.0.0.0:3000/website/page4",
            "http://0.0.0.0:3000/website/page5"]
            
    url = urls[rand(urls.size)]
    
    a = Action.find_by_url(url)
    if a.nil? 
      a = Action.new(:url=>"#{url}", :url_id=> Digest::MD5.hexdigest(url), :kind => rand(2)) 
    end
    
    return a
    
    
  end
  
end
