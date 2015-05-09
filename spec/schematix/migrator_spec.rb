# -*- coding: utf-8 -*-
require 'spec_helper'

module Schematix
  describe Migrator do
    def current_schema
      # Not Memoized (so not using let) because we always want the latest dump at any point in time
      Schematix::Schema.dump(adapter)
    end

    let(:expected_schema) {
      Schematix::Schema.define do
        table :users do
          column :id, :integer
          column :email, :string
          column :username, :string
        end
      end
    }

    context "Adding missing tables" do
      before do
        expect(current_schema.tables[:users]).to be_nil
        Schematix::Migrator.new(adapter).migrate_to(expected_schema)
      end

      it "adds the users table" do
        expect(current_schema.tables[:users]).not_to be_nil
      end
    end

    context "Dropping unneeded tables" do
      before do
        adapter.execute("CREATE TABLE articles (id int, email varchar);")
        Schematix::Migrator.new(adapter).migrate_to(expected_schema)
      end

      it "drops the articles table" do
        expect(current_schema.tables[:articles]).to be_nil
      end
    end

    context "Adding missing columns" do
      before do
        adapter.execute("CREATE TABLE users (id int, email varchar);")
        Schematix::Migrator.new(adapter).migrate_to(expected_schema)
      end

      it "adds the missing columns" do
        expect(current_schema.tables[:users].columns[:username].type).to be(:string)
      end
    end

    context "Removing unneeded columns" do
      before do
        adapter.execute("CREATE TABLE users (id int, email varchar, username varchar, password varchar);")
        Schematix::Migrator.new(adapter).migrate_to(expected_schema)
      end

      it "removes the extra column" do
        expect(current_schema.tables[:users].columns[:password]).to be_nil
      end
    end
  end
end
