# -*- coding: utf-8 -*-
require 'pg'

module Schematix
  module Adapters
    class Postgresql
      def initialize(options={})
        @connection = PG.connect(options)
      end
      attr_reader :connection

      def create_table(table)
        sql = "CREATE TABLE #{table.name} (\n"
        columns_sql = []
        table.columns.each do |column|
          columns_sql << [" ", column.name, type_to_sql(column.type)].join(' ')
        end
        sql << columns_sql.join(",\n")
        sql << "\n);"

        execute sql
      end

      def create_view(view)
        execute "CREATE VIEW #{view.name} AS #{view.sql}"
      end

      def drop_table(table)
        sql = "DROP TABLE #{table.name};"

        execute sql
      end

      def add_column(table, column)
        sql = "ALTER TABLE #{table.name} ADD COLUMN #{column.name} #{type_to_sql(column.type)};"

        execute sql
      end

      def drop_column(table, column)
        sql = "ALTER TABLE #{table.name} DROP COLUMN #{column.name};"

        execute sql
      end

      def change_column(table, current_column, expected_column)
        sql = "ALTER TABLE #{table.name} "
        changes = []
        if current_column.type != expected_column.type
          changes << "TYPE #{type_to_sql(expected_column.type)}"
        end
        if current_column.nullable != expected_column.nullable
          changes << "#{current_column.nullable ? 'SET' : 'DROP'} NOT NULL"
        end
        if current_column.default != expected_column.default
          if expected_column.default.nil?
            changes << "DROP DEFAULT"
          else
            changes << "SET DEFAULT #{default_to_sql(expected_column.default)}"
          end
        end
        changes.map!{|ch| "ALTER COLUMN #{current_column.name} #{ch}" }
        sql << changes.join(', ')

        execute sql
      end

      def drop_view(view)
        sql = "DROP VIEW #{view.name};"

        execute sql
      end


      def each_table
        rs = execute("SELECT tablename FROM pg_tables WHERE schemaname = 'public' ORDER BY tablename")
        rs.each do |row|
          yield row['tablename']
        end
      end

      def each_column(table_name)
        rs = execute("SELECT column_name, data_type, character_maximum_length, is_nullable, column_default FROM information_schema.columns WHERE table_schema = 'public' AND table_name = '#{table_name}' ORDER BY ordinal_position")
        rs.each do |row|
          type = sql_to_type(row['data_type'])
          yield Hash(name: row['column_name'], type: type, nullable: row['is_nullable'] == 'YES', default: parse_default(row['column_default'], type))
        end
      end

      def each_view
        rs = execute("SELECT viewname, definition FROM pg_views WHERE schemaname = 'public' ORDER BY viewname")
        rs.each do |row|
          yield Hash(name: row['viewname'], source: row['definition'])
        end
      end

      def execute(sql)
        connection.exec sql
      end

      private
      def type_to_sql(type)
        case type
        when :string
          'varchar'
        else
          type
        end
      end

      def sql_to_type(type)
        case type
        when 'character varying'
          :string
        else
          type.to_sym
        end
      end

      def parse_default(default_string, type)
        return nil if default_string.nil?
        case type
        when :string, :text
          default_string.sub(/\A'(.*?)'::.+\z/, '\1')
        when :integer
          default_string.to_i
        end
      end

      def default_to_sql(default)
        if default.is_a?(String)
          "'#{default}'::text"
        else
          default.to_s
        end
      end
    end
  end
end
