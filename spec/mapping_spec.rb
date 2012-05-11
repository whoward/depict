require 'spec_helper'

describe Guise::Mapping do
   subject { Guise::Mapping }

   let(:name_mapping) { subject.new(:name) }

   it "should assign the attribute name" do
      subject.new(:id).name.should == :id
   end

   it "should symbolize string attribute names" do
      subject.new("id").name.should == :id
   end

   it "should assign the :with object as the converter" do
      mapping = subject.new(:created_at, :with => Guise::Converters::UnixTimestamp)

      mapping.converter.should == Guise::Converters::UnixTimestamp
   end

   context "serialization" do
      let(:attrs) { {} }
      let(:object) { OpenStruct.new(:timestamp => Time.utc(2012, 1, 1, 0, 0, 0)) }

      it "should assign a serialized value to a given hash" do      
         subject.new(:timestamp).serialize(object, attrs)

         attrs[:timestamp].should == Time.utc(2012, 1, 1, 0, 0, 0)
      end

      it "should assign a serialized value using the converter to a given hash" do
         subject.new(:timestamp, :with => Guise::Converters::UnixTimestamp).serialize(object, attrs)

         attrs[:timestamp].should == 1325376000000
      end

      it "should write to the :as attribute name" do
         subject.new(:timestamp, :as => :created_at).serialize(object, attrs)

         attrs[:created_at].should == Time.utc(2012, 1, 1, 0, 0, 0)
      end

   end

   context "deserialization" do
      let(:attrs) { {:timestamp => 1325376000000 } }
      let(:object) { OpenStruct.new }

      it "should assign the value from the given hash" do
         subject.new(:timestamp).deserialize(object, attrs)

         object.timestamp.should == 1325376000000
      end

      it "should assign the value using the converter from the given hash" do
         subject.new(:timestamp, :with => Guise::Converters::UnixTimestamp).deserialize(object, attrs)

         object.timestamp.should == Time.utc(2012, 1, 1, 0, 0, 0)
      end

      it "should read from the :as attribute name" do
         subject.new(:created_at, :as => :timestamp).deserialize(object, attrs)

         object.created_at.should == 1325376000000
      end
   end

end