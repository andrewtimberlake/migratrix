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
          table.column column[:name], column[:type], null: column[:nullable], default: column[:default]
        end
      end
      schema
    end

    def self.migrate(adapter, expected_schema)
      Migrator.new(adapter).migrate_to(expected_schema)
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
