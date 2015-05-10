# -*- coding: utf-8 -*-
module Schematix
  class Migrator
    def initialize(adapter)
      @adapter = adapter
    end
    attr_reader :adapter

    def migrate_to(expected_schema)
      add_missing_tables_and_columns(expected_schema)
      add_missing_views(expected_schema)
      drop_unneeded_views(expected_schema)
      drop_unneeded_tables_or_columns(expected_schema)
    end

    private
    def add_missing_tables_and_columns(expected_schema)
      expected_schema.tables.each do |expected_table|
        current_table = current_schema.tables[expected_table.name]
        if current_table.nil?
          adapter.create_table(expected_table)
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
    end

    def add_missing_views(expected_schema)
      expected_schema.views.each do |expected_view|
        current_view = current_schema.views[expected_view.name]

        if current_view.nil?
          adapter.create_view(expected_view)
        end
      end
    end

    def drop_unneeded_views(expected_schema)
      current_schema.views.each do |current_view|
        expected_view = expected_schema.views[current_view.name]

        if expected_view.nil?
          adapter.drop_view(current_view)
        end
      end
    end

    def drop_unneeded_tables_or_columns(expected_schema)
      current_schema.tables.each do |current_table|
        expected_table = expected_schema.tables[current_table.name]

        if expected_table.nil?
          adapter.drop_table(current_table)
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

    def current_schema
      @current_schema ||= Schema.dump(adapter)
    end
  end
end
