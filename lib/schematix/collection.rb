# -*- coding: utf-8 -*-
module Schematix
  class Collection
    include Enumerable

    def initialize
      @hash = Hash.new
    end

    def <<(item)
      @hash[item.name.to_s] = item
    end

    def [](key_or_id)
      if key_or_id.is_a?(Integer)
        @hash.values[key_or_id]
      else
        @hash[key_or_id.to_s]
      end
    end

    def each
      @hash.each do |k, value|
        yield value
      end
    end

    def size
      @hash.size
    end
  end
end
