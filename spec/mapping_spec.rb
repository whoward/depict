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
      conv = Guise::Converters::UnixTimestamp.new

      mapping = subject.new(:created_at, :with => conv)

      mapping.converter.should == conv
   end

   it "should instantiate any class given as the :with parameter as the converter" do
      mapping = subject.new(:id, :with => Guise::Converters::UnixTimestamp)

      mapping.converter.should be_an_instance_of Guise::Converters::UnixTimestamp
   end

   context "serialization" do
      let(:output) { {} }
      let(:object) { OpenStruct.new(:timestamp => Time.utc(2012, 1, 1, 0, 0, 0)) }

      it "should assign a serialized value to a given hash" do      
         subject.new(:timestamp).serialize(object, output)

         output[:timestamp].should == Time.utc(2012, 1, 1, 0, 0, 0)
      end

      it "should assign a serialized value using the converter to a given hash" do
         subject.new(:timestamp, :with => Guise::Converters::UnixTimestamp).serialize(object, output)

         output[:timestamp].should == 1325376000000
      end

   end

end