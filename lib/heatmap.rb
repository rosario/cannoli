
require 'rubygems'
require 'RMagick'

module Heatmap

  DOTIMAGE = "#{RAILS_ROOT}/lib/bolillamia16.png"
  COLORIMAGE ="#{RAILS_ROOT}/lib/colors.png"
  OPACITY = 0.8
  DOTWIDTH = 16
  
  
  class Point
      def initialize(x,y)
          @x=x
          @y=y
      end
      def x
          return @x.to_i
      end
      def y
          return @y.to_i
      end
      def xy
          return "x"+@x.to_s+"y"+@y.to_s
      end
  end
  
  
  class Log
      def initialize (x,y,list)
          @line = 0
          @x=x
          @y=y
          
          @list=list
          @points = Hash.new(0)
          @list.each do |point|
              @points[point.xy] +=1
          end
          @reps = @points.values.max
      end
      attr_reader :x, :y, :list, :reps
      def next
          coord = @list[@line]
          @line += 1
          return coord
      end
  end
  
  


  class ReadClicks
    # We expect that the each element of the list cs has got two attribute, x and y 
    def initialize(cs)
      @data = []
      
      for c in cs        
        @data.push(Point.new(c.x, c.y))
      end
      
    end
    
    
    def coords
      xMax=0
      yMax=0
      coords = Array.new
      @data.each do |line|
          coords.push(line)
          xMax=line.x if line.x>xMax
          yMax=line.y if line.y>yMax
      end
      return Log.new(xMax,yMax,coords)
    end
  end
  
  
  
  class Image
    
    
    def self.graymap(points)


        file = ReadClicks.new(points)    
        pagedata = file.coords

        # Create click-dot, colorized 
        intensity = (100-(100/pagedata.reps))/100.to_f
        click_image = Magick::Image.read(DOTIMAGE).first.colorize(intensity,intensity,intensity,'white')    

        # Create overlay image
        halfwidth = DOTWIDTH/2
        image = Magick::Image.new(pagedata.x+halfwidth, pagedata.y+halfwidth) { self.background_color = 'transparent'}

        puts "Adding clicks"
        # Add click dots
        pagedata.list.each do |coords|
          image.composite!(click_image,coords.x-halfwidth,coords.y-halfwidth, Magick::MultiplyCompositeOp)
        end
        puts "Image composed"
        image = image.negate
        return image
      
    end
    
    
    def self.create_graymap(graymap_file,points)
      
      image = graymap(points)
      image.write(graymap_file)
    
      puts "Done with #{graymap_file}\n" 
    end
    
    
    
    def self.create_heatmap(heatmap_file,points)

      if points.empty?
        system("touch #{heatmap_file}")
      else
        
        image = graymap(points)
        colorimage = Magick::Image.read(COLORIMAGE).first
       
        imagelist =  Magick::ImageList.new
        imagelist <<  image.clut_channel(colorimage)
        imagelist.fx("A*0.8",Magick::AlphaChannel).blur_image.write(heatmap_file)
        
#        image.write(heatmap) { self.quality = 50 }

        puts "Done with #{heatmap_file}\n" 
      end
    end
    


  end
end

