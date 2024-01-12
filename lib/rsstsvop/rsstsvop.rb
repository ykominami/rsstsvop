# frozen_string_literal: true

require "open-uri"
require "yaml"

module Rsstsvop
  # RSS-TSV操作クラス
  class Rsstsvop
    attr_reader :content, :content_array, :url, :user, :passwd, :fname

    def initialize(hash)
      @url = hash["url"]
      @user = hash["user"]
      @passwd = hash["passwd"]
      @fname = hash["fname"]
    end

    def load_yaml(pan)
      YAML.load_file(pan)
    end

    def get
      @content = if !@user.nil? && !@passwd.nil?
                   open(@url, http_basic_authentication: [@user, @passwd]).read
                 else
                   open(@url).read
                 end

      self
    end

    def save
      #      puts "== save"
      File.open(@fname, "w", { encoding: Encoding::UTF_8 }) do |f|
        f.write(@content)
      end

      self
    end

    def read_from_file
      File.open(@fname, "r", { encoding: Encoding::UTF_8 }) do |f|
        @content = f.read
      end
      self
    end

    def read_from_file_to_array
      @content_array = []
      File.open(@fname, "r", { encoding: "BOM|UTF-8" }) do |f|
        until (l = f.gets).nil?
          @content_array << l.chomp!
        end
      end

      self
    end
  end
end
