# -*- coding: utf-8 -*-
module Schematix
  class Migrator
    def initialize(adapter)
      @adapter = adapter
    end
    attr_reader :adapter

    def migrate_to(expected_schema)
      current_schema = Schema.dump(adapter)
      current_schema.tables.each do |current_table|
        expected_table = expected_schema.tables[current_table.name]
        if expected_table.nil?
          adapter.drop_table(current_table)
        else
          expected_table.columns.each do |expected_column|
            current_column = current_table.columns[expected_column.name]
            if current_column.nil?
              adapter.add_column current_table, expected_column
            else
              if current_column != expected_column
                adapter.change_column(current_table, current_column, expected_column)
              end
            end
          end
        end
      end
      expected_schema.tables.each do |expected_table|
        current_table = current_schema.tables[expected_table.name]
        if current_table.nil?
          adapter.create_table(expected_table)
        else
          current_table.columns.each do |current_column|
            expected_column = expected_table.columns[current_column.name]
            if expected_column.nil?
              adapter.drop_column current_table, current_column
            end
          end
        end
      end
    end
  end
end
