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
      let(:schema) { Schematix::Schema.dump(adapter) }

      before do
        adapter.execute("CREATE TABLE users (id int, email varchar(100)); CREATE TABLE articles (title varchar, body text);")
      end

      it "has 2 tables" do
        expect(schema.tables.size).to be(2)
      end

      context "the users table" do
        let(:table) { schema.tables[:users] }

        it "has 2 columns" do
          expect(table.columns.size).to be(2)
        end

        it "has an id column" do
          expect(table.columns[:id].type).to eq(:integer)
        end

        it "has an email column" do
          expect(table.columns[:email].type).to eq(:string)
        end
      end

      context "the articles table" do
        let(:table) { schema.tables[:articles] }

        it "has 2 columns" do
          expect(table.columns.size).to be(2)
        end

        it "has an id column" do
          expect(table.columns[:title].type).to eq(:string)
        end

        it "has an email column" do
          expect(table.columns[:body].type).to eq(:text)
        end
      end
    end

    context "migrating a schema" do
      let(:expected_schema) {
        Schematix::Schema.define do
          table :users do
            column :id, :integer
            column :email, :string
            column :username, :string
          end
        end
      }

      before do
        adapter.execute("CREATE TABLE users (id int, email varchar(100));")
        Schematix::Schema.migrate(adapter, expected_schema)
      end

      it "adds the missing columns" do
        schema = Schematix::Schema.dump(adapter)
        expect(schema.tables[:users].columns[:username].type).to be(:string)
      end
    end
  end
end
