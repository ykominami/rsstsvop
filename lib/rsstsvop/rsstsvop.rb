require 'open-uri'
require 'yaml'

module Rsstsvop
  class Rsstsvop
    attr_reader :content , :content_array, :url, :user, :passwd, :fname

    def initialize( hash )
      @url = hash["url"]
      @user = hash["user"]
      @passwd = hash["passwd"]
      @fname = hash["fname"]
    end
    
    def load_yaml( pn )
      YAML.load_file( pn )
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
#      puts "== save"
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

    def read_from_file_to_array
      @content_array = []
      File.open( @fname , 'r' , {encoding: 'BOM|UTF-8'} ){|f|
        while l = f.gets
          @content_array << l.chomp!
        end
      }
      
      self
    end
    
  end
end
