# -*- coding: utf-8 -*-
module Schematix
  class Schema
    def self.define(&block)
      schema = Schema.new
      schema.instance_eval(&block)
      schema
    end

    def initialize
      @tables = []
    end
    attr_reader :tables

    def table(name)
      tables << Table.new(name)
    end
  end

  class Table
    def initialize(name)
      @name = name
    end
    attr_reader :name
  end
end
