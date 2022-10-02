# frozen_string_literal: true

require 'csv'

module Rsstsvop
  # TSV操作クラス
  class Tsvop < Rsstsvop
    def initialize(index, yaml_pn)
      yaml_data = load_yaml(yaml_pn)
      super(yaml_data['tsv'][index])
    end

    def csv_pars_sub(fields, val)
      if fields.size > @headers.size
        puts 'error 1!'
        raise
      elsif fields.size == @headers.size
        if val.empty?
          hash = {}
          0.upto(fields.size - 1).each do |x2|
            hash[@headers[x2]] = fields[x2]
          end
          @parsed_data << hash
        else
          puts 'error 2!'
          raise
        end
      else
        hash = {}
        0.upto(fields.size - 1).each do |x3|
          hash[@headers[x]] = fields[x3]
        end

        tail_line = x.pop
        tail_fields = tail_line.split("\t")
        case tail_fields.size
        when 1
          hash[@headers.last] = tail_fields[0]
        when 2
          hash[@headers.last] = tail_fields.last
          x.push(tail_fields[0])
        else
          hash[@headers.last] = tail_fields.last
          val, _tmp = tail_line.split("\t#{tail_fields.last}")
          x.push(val)
        end
        hash[@headers[-2]] = x.join("\n")

        @parsed_data << hash
      end
    end

    def csv_parse(array, **_options)
      @parsed_data = []
      rows = []
      data_rows = array
      @headers = data_rows.shift.split("\t")

      item_lines = nil
      data_rows.each do |x|
        if x =~ /^[[:digit:]]+\t/
          rows << item_lines if item_lines
          item_lines = []
        end
        if item_lines.nil?
          puts x
          puts 'error a1'
          raise
        end
        item_lines << x
      end
      rows << item_lines if item_lines.size.positive?

      cnt = 0
      rows.map do |x2|
        cnt += 1
        fields = x2.shift.split("\t")
        csv_pars_sub(fields, x2)
      end

      @parsed_data
    end

    def parse
      # headers of tsv file
      #
      # ticket	summary	component	version	milestone	type	owner	status	created	_changetime	_description	_reporter
      @items_by_id = {}
      @items_by_component = {}
      @items_by_version = {}
      @items_by_milestone = {}
      @items_by_type = {}
      @items_by_owner = {}
      @items_by_status = {}
      @items_by_reporter = {}

      #      @csv_data = CSV.parse( @content , { :headers => true } )
      @csv_data = csv_parse(@content_array, { headers: true })

      @csv_data.each do |data|
        @items_by_id[data['ticket']] = data
      end

      self
    end

    def setup_data(hash, key)
      return unless hash.size.zero?

      @csv_data.each do |data|
        hash[data[key]] ||= []
        hash[data[key]] << data
      end
    end

    def print_key_values(hash, id_key)
      hash.each do |k, v|
        puts "* #{k}"
        puts v.map { |x| format('#%s', x[id_key]) }.join(',')
      end
    end

    def print_by_component
      setup_data(@items_by_component, 'component')
      print_key_values(@items_by_component, 'ticket')
    end

    def print_by_version
      setup_data(@items_by_version, 'version')
      print_key_values(@items_by_version, 'ticket')
    end

    def print_by_milestone
      setup_data(@items_by_milestone, 'milestorn')
      print_key_values(@items_by_milestone, 'ticket')
    end

    def print_by_type
      setup_data(@items_by_type, 'type')
      print_key_values(@items_by_type, 'ticket')
    end

    def print_by_owner
      setup_data(@items_by_owner, 'owner')
      print_key_values(@items_by_owner, 'ticket')
    end

    def print_by_status
      setup_data(@items_by_status, 'statur')
      print_key_values(@items_by_status, 'ticket')
    end

    def print_by_reporter
      setup_data(@items_by_reporter, 'reporter')
      print_key_values(@items_by_reporter, 'ticket')
    end

    def print_table(dir)
      dirpn = Pathname.new(dir)
      dirpn.rmtree if dirpn.exist?
      dirpn.mkdir
      fields = %w[ticket summary component version milestone type owner status created _changetime _reporter]
      table = @items_by_id.map do |_k, v|
        (dirpn / "#{v['ticket']}.txt").write(v['_description'])
        fields.map { |x| v[x] }.join("\t")
      end.join("\n")
      puts table
    end

    # for debug
    def print_key
      puts 'print_key'
      @items_by_component.each do |k, v|
        puts "* #{k}"
        if v && v[0] && v[0].keys
          puts v[0].keys.join(',')
        else
          puts ' - '
        end
      end
    end
  end
end
