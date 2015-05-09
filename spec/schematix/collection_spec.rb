# -*- coding: utf-8 -*-
require 'spec_helper'
require 'schematix/collection'
require 'schematix/schema'

module Schematix
  describe Collection do
    let(:collection) { Collection.new }

    it "can add elements" do
      collection << Table.new('users')
      expect(collection.size).to be(1)
    end

    it "can access an element by name" do
      table = Table.new(:users)
      collection << table
      expect(collection['users']).to be(table)
    end

    it "can access an element by name as a symbol" do
      table = Table.new('users')
      collection << table
      expect(collection[:users]).to be(table)
    end

    it "can iterate the collection" do
      collection << Table.new(:users)
      collection << Table.new(:articles)
      expect(collection.map(&:name)).to eq(%w[users articles])
    end
  end
end
