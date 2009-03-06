# The Tracker class is used to recognize the visitor
class Tracker

 
  
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
       	# The time the request is done by the user using at his local time 
       	:localtime => p[:utc].to_s.to_time  # THIS does NOT go into the md5 hash
       }

      return user_settings


     end
  
 
  
end
