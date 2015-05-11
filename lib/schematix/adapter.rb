# -*- coding: utf-8 -*-
module Schematix
  class Adapter
    def self.register(key, adapter_class)
      adapters[key] = adapter_class
    end

    def self.for(key)
      adapter = @adapters[key]
      require "schematix/adapters/#{adapter.downcase}"
      Adapters.const_get(adapter)
    end

    private
    def self.adapters
      @adapters ||= {}
    end
  end
end
