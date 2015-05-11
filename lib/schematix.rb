# -*- coding: utf-8 -*-
module Schematix
  VERSION = "0.0.1"

  require 'schematix/collection'
  require 'schematix/table'
  require 'schematix/column'
  require 'schematix/view'
  require 'schematix/migrator'
  require 'schematix/schema'

  require 'schematix/adapter'
  Adapter.register :postgresql, 'Postgresql'
end
