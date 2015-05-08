# -*- coding: utf-8 -*-
require 'spec_helper'
spec_require 'schema'
spec_require 'adapters/postgresql'

module Schematix
  describe Schema do
    context "defining a schema" do
      let(:schema) {
        Schematix::Schema.define do
          table :users do
            column :email, :string
          end
          table :articles do
            column :title, :string
            column :body,  :text
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

    context "dumping a schema" do
      let(:adapter) { Schematix::Adapters::Postgresql.new(dbname: 'schematix') }
      let(:schema) { Schematix::Schema.dump(adapter) }

      before do
        adapter.execute("CREATE TABLE users (id int, email varchar(100)); CREATE TABLE articles (title varchar, body text);")
      end

      after do
        adapter.execute("DROP TABLE users; DROP TABLE articles")
      end

      it "has 2 tables" do
        expect(schema.tables.size).to be(2)
      end

      context "the users table" do
        it "has 2 columns" do
          expect(schema.tables[:users].columns.size).to be(2)
        end
      end
    end
  end
end
