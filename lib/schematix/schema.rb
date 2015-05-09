# -*- coding: utf-8 -*-
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
end
