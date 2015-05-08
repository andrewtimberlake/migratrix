# -*- coding: utf-8 -*-
module Schematix
  class Schema
    def self.define(&block)
      schema = Schema.new
      schema.instance_eval(&block)
      schema
    end

    def initialize
      @tables = Hash.new
    end
    attr_reader :tables

    def table(name, &block)
      tables[name] = Table.new(name, &block)
    end
  end

  class Table
    def initialize(name, &block)
      @name = name
      @columns = Hash.new
      self.instance_eval(&block) if block_given?
    end
    attr_reader :name, :columns

    def column(name, type, options={})
      columns[name] = Column.new(name, type, options)
    end
  end

  class Column
    def initialize(name, type, options={})
      @name = name
      @type = type
    end
    attr_reader :name, :type

    def sql_type
      case type
      when :string
        'varchar'
      else
        type
      end
    end
  end
end
