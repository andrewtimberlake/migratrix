# -*- coding: utf-8 -*-
require 'schematix/collection'

module Schematix
  class Schema
    def self.define(&block)
      schema = Schema.new
      schema.instance_eval(&block)
      schema
    end

    def self.dump(adapter)
      schema = Schema.new
      adapter.each_table do |name|
        table = schema.table name
        adapter.each_column(name) do |column|
          table.column column[:name], column[:type]
        end
      end
      schema
    end

    def initialize
      @tables = Collection.new
    end
    attr_reader :tables

    def table(name, &block)
      tables << Table.new(name, &block)
    end
  end

  class Table
    def initialize(name, &block)
      @name = name
      @columns = Collection.new
      self.instance_eval(&block) if block_given?
    end
    attr_reader :name, :columns

    def column(name, type, options={})
      columns << Column.new(name, type, options)
    end
  end

  class Column
    def initialize(name, type, options={})
      @name = name
      @type = type
    end
    attr_reader :name, :type
  end
end
