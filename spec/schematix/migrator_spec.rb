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

    context "Adding a missing table" do
      before do
        expect(current_schema.tables[:users]).to be_nil
        Schematix::Migrator.new(adapter).migrate_to(expected_schema)
      end

      it "adds the users table" do
        expect(current_schema.tables[:users]).not_to be_nil
      end
    end

    context "Dropping an unneeded table" do
      before do
        adapter.execute("CREATE TABLE articles (id int, email varchar);")
        Schematix::Migrator.new(adapter).migrate_to(expected_schema)
      end

      it "drops the articles table" do
        expect(current_schema.tables[:articles]).to be_nil
      end
    end

    context "Adding a missing column" do
      before do
        adapter.execute("CREATE TABLE users (id int, email varchar);")
        Schematix::Migrator.new(adapter).migrate_to(expected_schema)
      end

      it "adds the missing columns" do
        expect(current_schema.tables[:users].columns[:username].type).to be(:string)
      end
    end

    context "Removing an unneeded column" do
      before do
        adapter.execute("CREATE TABLE users (id int, email varchar, username varchar, password varchar);")
        Schematix::Migrator.new(adapter).migrate_to(expected_schema)
      end

      it "removes the extra column" do
        expect(current_schema.tables[:users].columns[:password]).to be_nil
      end
    end

    context "Changing a column type" do
      let(:expected_schema) {
        Schematix::Schema.define do
          table :articles do
            column :title, :string
            column :body, :text
          end
        end
      }
      before do
        adapter.execute("CREATE TABLE articles (title varchar, body varchar)")
        Schematix::Migrator.new(adapter).migrate_to(expected_schema)
      end

      it "changes the column type" do
        expect(current_schema.tables[:articles].columns[:body].type).to eq(:text)
      end
    end

    context "Changing a column nullability" do
      let(:expected_schema) {
        Schematix::Schema.define do
          table :articles do
            column :title, :string, null: false
            column :body, :text
          end
        end
      }
      before do
        adapter.execute("CREATE TABLE articles (title varchar null, body varchar)")
        expect(current_schema.tables[:articles].columns[:title].nullable).to be(true)
        Schematix::Migrator.new(adapter).migrate_to(expected_schema)
      end

      it "changes the column nullablity" do
        expect(current_schema.tables[:articles].columns[:title].nullable).to be(false)
      end
    end

    context "Changing a column default" do
      let(:expected_schema) {
        Schematix::Schema.define do
          table :stats do
            column :counter1, :integer, null: false, default: 0
            column :counter2, :integer, null: false
          end
        end
      }
      before do
        adapter.execute("CREATE TABLE stats (counter1 integer, counter2 integer NOT NULL DEFAULT 0)")
        Schematix::Migrator.new(adapter).migrate_to(expected_schema)
      end

      it "adds a missing default" do
        expect(current_schema.tables[:stats].columns[:counter1].default).to eq(0)
      end

      it "removes a default" do
        expect(current_schema.tables[:stats].columns[:counter2].default).to be_nil
      end
    end
  end
end
