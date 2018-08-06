require 'rss'

module Rssop
  class Rssop
    attr_reader :content
    
    def initialize( index )
      hash = @@config[index]
      pp hash
      @url = hash[:url]
      @user = hash[:user]
      @passwd = hash[:passwd]
      @fname = hash[:fname]
    end

    def get
      if @user != nil and @passwd != nil
        @content = open(@url, http_basic_authentication: [@user, @passwd]).read
      else
        @content = open(@url).read
      end
      
      self
    end

    def save
      File.open( @fname , 'w' , {encoding: Encoding::UTF_8} ){|f|
        f.write( @content )
      }
      
      self
    end

    def read_from_file
      File.open( @fname , 'r' , {encoding: Encoding::UTF_8} ){|f|
        @content = f.read
      }
      
      self
    end

    def parse( validation=true )
      @rss = RSS::Parser.parse(@content,validation)
      
      self
    end

    def print_title_list
      @rss.channel.items.each do |x|
        puts x.title
      end
    end

    def print_all_items
      @rss.items.map{|item|
        puts item.pubDate.strftime( "%Y/%m/%d" )
        puts item.category.content
        puts item.title
        puts item.link
        puts item.description
        puts
      }
    end
  end
end

#rssop = Rssop::Rssop.new(2)
#rssop.get.save.parse.print_title_list
rssop = Rssop::Rssop.new(22)
rssop.get.save.parse(false).print_all_items
#rssop.read_from_file.parse(false).print_title_list
#rssop.read_from_file.parse(false).print_all_items

