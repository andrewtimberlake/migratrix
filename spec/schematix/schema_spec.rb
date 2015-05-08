# -*- coding: utf-8 -*-
require 'spec_helper'
spec_require 'schema'

module Schematix
  describe Schema do
    context "building a table" do
      let(:schema) {
        Schematix::Schema.define do
          table :users
          table :articles
        end
      }

      it "has 2 tables" do
        expect(schema.tables.size).to be(2)
      end
    end
  end
end
