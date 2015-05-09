# -*- coding: utf-8 -*-
module Schematix
  class Table
    def initialize(name, &block)
      @name = name
      @columns = Collection.new
      self.instance_eval(&block) if block_given?
    end
    attr_reader :name, :columns

    def column(name, type, options={})
      columns << Column.new(name, type, options)
    end
  end
end
