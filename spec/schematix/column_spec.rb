# -*- coding: utf-8 -*-
require 'spec_helper'

module Schematix
  describe Column do
    context "equality" do
      it "is equal if the names and types are the same" do
        expect(Column.new('col', :string)).to eq(Column.new('col', :string))
      end

      it "is NOT equal if the names are different" do
        expect(Column.new('col1', :string)).not_to eq(Column.new('col2', :string))
      end

      it "is NOT equal if the types are different" do
        expect(Column.new('col', :string)).not_to eq(Column.new('col', :integer))
      end

      it "is NOT equal if the nullability is different" do
        expect(Column.new('col', :string, null: true)).not_to eq(Column.new('col', :string, null: false))
      end

      it "is NOT equal if the default is different" do
        expect(Column.new('col', :string, default: '')).not_to eq(Column.new('col', :string, default: nil))
      end
    end
  end
end
