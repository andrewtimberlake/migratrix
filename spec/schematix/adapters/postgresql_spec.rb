# -*- coding: utf-8 -*-
require 'spec_helper'
spec_require 'schema'
spec_require 'adapters/postgresql'

module Schematix
  module Adapters
    describe Postgresql do
      let(:schema) {
        Schematix::Schema.define do
          table :users do
            column :email, :string
          end
        end
      }
      let(:db) { Schematix::Adapters::Postgresql.new(dbname: 'schematix') }

      it "creates the table" do
        expect { db.create_table schema.tables[:users] }.not_to raise_error
      end

      it "drops the table" do
        db.execute("CREATE TABLE users ()")
        expect { db.drop_table schema.tables[:users] }.not_to raise_error
      end
    end
  end
end
