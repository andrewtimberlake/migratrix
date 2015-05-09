# -*- coding: utf-8 -*-
module Schematix
  class Schema
    def self.define(&block)
      schema = Schema.new
      schema.instance_eval(&block) if block_given?
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

    def self.migrate(adapter, expected_schema)
      current_schema = dump(adapter)
      current_schema.tables.each do |current_table|
        expected_table = expected_schema.tables[current_table.name]
        if expected_table.nil?
          adapter.drop_table(current_table)
        else
          expected_table.columns.each do |expected_column|
            current_column = current_table.columns[expected_column.name]
            if current_column.nil?
              adapter.add_column current_table, expected_column
            end
          end
        end
      end
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
