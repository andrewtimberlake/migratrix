# -*- coding: utf-8 -*-
module Schematix
  class Column
    def initialize(name, type, options={})
      @name = name
      @type = type
    end
    attr_reader :name, :type

    def inspect
      "#<Column #{name}>"
    end
  end
end
