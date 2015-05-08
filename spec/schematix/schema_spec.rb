# -*- coding: utf-8 -*-
require 'spec_helper'
spec_require 'schema'

module Schematix
  describe Schema do
    context "building a table" do
      let(:schema) {
        Schematix::Schema.define do
          table :users do
            column :email, :string
          end
          table :articles do
            column :title, :string
            column :body,  :string
          end
        end
      }

      it "has 2 tables" do
        expect(schema.tables.size).to be(2)
      end

      context "the user table" do
        let(:table) { schema.tables[:users] }

        it "has one column" do
          expect(table.columns.size).to be(1)
        end
      end
    end
  end
end
