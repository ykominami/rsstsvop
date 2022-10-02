# frozen_string_literal: true

require 'rss'

module Rsstsvop
  # RSS操作クラス
  class Rssop < Rsstsvop
    def initialize(index, yaml_pn)
      yaml_data = load_yaml(yaml_pn)
      super(yaml_data['rss'][index])
    end

    def parse(validation = false)
      @rss = RSS::Parser.parse(@content, validation)

      self
    end

    def print_title_list
      @rss.channel.items.each do |x|
        puts x.title
      end
    end

    def print_all_items
      @rss.items.map do |item|
        puts item.pubDate.strftime('%Y/%m/%d')
        puts item.category.content
        puts item.title
        puts item.link
        puts item.description
        puts
      end
    end
  end
end
