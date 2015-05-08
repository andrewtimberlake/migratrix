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
        table.columns.values.each do |column|
          columns_sql << [" ", column.name, column.sql_type].join(' ')
        end
        sql << columns_sql.join(",\n")
        sql << "\n);"

        execute sql
      end

      def drop_table(table)
        sql = "DROP TABLE #{table.name};"

        execute sql
      end

      private
      def execute(sql)
        connection.exec sql
      end
    end
  end
end
