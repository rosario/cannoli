# The Tracker class is used to recognize the visitor
class Tracker

  REFERER_TYPE_CAMPAIGN = 0
  REFERER_TYPE_SEARCH_ENGINE = 1
  REFERER_TYPE_DIRECT_ENTRY = 2
  REFERER_TYPE_WEBSITE = 3
 
  
  # Check if the query of the url contains "campaign_name"  and "campaign_keyword"
     def self.check_campaign(string)
          query = URI.parse(string).query

          refs = {}
       
          if not query.nil? 
            hash = CGI.parse(query)          
            if hash.has_key? "campaign_name"
              # CGI parse return a list, that's why I only get the first element
              refs["campaign_name"] = hash["campaign_name"].first
            end
          
            if hash.has_key? "campaign_keyword"
              refs["campaign_keyword"] = hash["campaign_keyword"].first
            end
          end
          
          return refs
      end
    

    # Get referer informations 
    
    def self.referer_info(urlref)
     
      
      # This is the name of the domain running the analysis... at the moment is just localhost
      # Later it should be the name of the host that signed up 
      actual_domain = "localhost"
     
     
      urlref = URI.encode(urlref)
      
      campaign = check_campaign(urlref)

      campaign_name = ""
      referer_name = URI.parse(urlref).host
      if not campaign.empty?
        
        referer_type = REFERER_TYPE_CAMPAIGN
        referer_keyword =  campaign["campaign_keyword"]
        campaign_name = campaign["campaign_name"]
        
      else
        search_engine = Parser::Keyword.search_engine(urlref)
        if not search_engine.nil?           
           referer_type = REFERER_TYPE_SEARCH_ENGINE
           referer_keyword = Parser::Keyword.get_terms(urlref)
           puts referer_keyword
           referer_name = search_engine
         elsif actual_domain == referer_name
           referer_type = REFERER_TYPE_DIRECT_ENTRY
           referer_keyword = ""
         else
           referer_type = REFERER_TYPE_WEBSITE
         end
         
         
           
      end
      
      return {:referer_name => referer_name, 
              :referer_keyword =>referer_keyword , 
              :referer_type => referer_type,
              :campaign_name => campaign_name
              }
          
       
    end
  
    # Return a user_settings hash, containin the information extracted from params[] and request.env
    def self.get_settings(p,r)


       # get user settings informations
       plugin_Flash 			  = p[:fla]
       plugin_Director 	  = p[:dir] 
       plugin_Quicktime	  = p[:qt] 
       plugin_RealPlayer   = p[:realp] 
       plugin_Pdf 			    = p[:pdf]
       plugin_WindowsMedia = p[:wma]
       plugin_Java 			  = p[:java]
       plugin_Cookie 		  = p[:cookie]
       resolution          = p[:res]

       user_agent = r.env['HTTP_USER_AGENT']

       os = Parser::UserAgent.get_platform(user_agent)
       browser  = Parser::UserAgent.browser_info(user_agent)    
       browserName = browser[:type]
       browserVersion = browser[:version]


       ip = r.remote_ip

       browserLang = r.env['HTTP_ACCEPT_LANGUAGE']

       refererinfo = referer_info(p[:urlref])
       
       configuration_hash = Digest::MD5.hexdigest(
         os + 
       	browserName +
       	browserVersion +
       	resolution +
       	plugin_Flash +
       	plugin_Director + 
       	plugin_RealPlayer +
       	plugin_Pdf + 
       	plugin_WindowsMedia +
       	plugin_Java +
       	plugin_Cookie +
       	ip +
       	browserLang
       )

       user_settings = { 
       	:config_md5config => configuration_hash,
       	:config_os 			=> os,
       	:config_browser_name 	=> browserName,
       	:config_browser_version => browserVersion,
       	:config_resolution 	=> resolution,
       	:config_pdf 			=> plugin_Pdf,
       	:config_flash 			=> plugin_Flash,
       	:config_java 			=> plugin_Java,
       	:config_director 		=> plugin_Director,
       	:config_quicktime 		=> plugin_Quicktime,
       	:config_realplayer 	=> plugin_RealPlayer,
       	:config_windowsmedia 	=> plugin_WindowsMedia,
       	:config_cookie 		=> plugin_Cookie,
       	:location_ip 			=> ip,
       	:location_browser_lang => browserLang,

       	# The following parameters do not go into the MD5 hash
       	# the request is done by the user using at his local time 
       	:localtime => p[:utc].to_s.to_time,
       	:referer_name => refererinfo[:referer_name], 
        :referer_keyword => refererinfo[:referer_keyword] , 
        :referer_type => refererinfo[:referer_type],
        :campaign_name =>refererinfo[:campaign_name], # This field is not stored in the DB ( at the moment )
        :referer_url => p[:urlref]
       }

      return user_settings


     end
  
 
  
end
