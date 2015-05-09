# -*- coding: utf-8 -*-
require 'spec_helper'

module Schematix
  describe Migrator do
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
      Schematix::Migrator.new(adapter).migrate_to(expected_schema)
    end

    it "adds the missing columns" do
      schema = Schematix::Schema.dump(adapter)
      expect(schema.tables[:users].columns[:username].type).to be(:string)
    end
  end
end
