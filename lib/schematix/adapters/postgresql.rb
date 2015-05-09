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

      def each_table
        rs = execute("SELECT table_name FROM information_schema.columns WHERE table_schema = 'public' GROUP BY table_name ORDER BY table_name")
        rs.each do |row|
          yield row['table_name']
        end
      end

      def each_column(table_name)
        rs = execute("SELECT column_name, data_type, character_maximum_length, is_nullable, column_default FROM information_schema.columns WHERE table_schema = 'public' AND table_name = '#{table_name}' ORDER BY ordinal_position")
        rs.each do |row|
          yield Hash(name: row['column_name'], type: sql_to_type(row['data_type']))
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
    end
  end
end
