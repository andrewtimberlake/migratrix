# -*- coding: utf-8 -*-
module Schematix
  class View
    def initialize(name, sql)
      @name = name.to_s
      @sql = sql
    end
    attr_reader :name, :sql

    def inspect
      "#<View #{name}>"
    end
  end
end
