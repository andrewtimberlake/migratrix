# -*- coding: utf-8 -*-
module Schematix
  class Column
    def initialize(name, type, options={})
      @name      = name.to_s
      @type      = type
      @nullable  = options.fetch(:null) { true }
      @default   = options.fetch(:default) { nil }
    end
    attr_reader :name, :type, :nullable, :default

    def inspect
      "#<Column #{name}>"
    end

    def ==(other)
      return false unless other.is_a?(Column)
      return false if other.name != self.name
      return false if other.type != self.type
      return false unless other.nullable == self.nullable
      return false unless other.default == self.default
      true
    end
    alias_method :eql?, :==
  end
end
