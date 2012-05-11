require 'spec_helper'
require 'ostruct'

describe Guise::Presenter do

   let(:user_presenter) do
      Guise::Presenter.define do
         maps :id
         maps :name
         maps :email, :as => :login
      end
   end
   
   it "should call the block given" do
      ran_block = false
      Guise::Presenter.define { ran_block = true }
      ran_block.should == true
   end

   it "should return a class which is a subclass of Guise::Presenter" do
      presenter = Guise::Presenter.define {}
      presenter.should be_an_instance_of Class
      presenter.superclass.should eql Guise::Presenter
   end

   it "should return a class which also define's the same #define method" do
      super_presenter = Guise::Presenter.define {}

      inhereted_presenter = super_presenter.define {}

      inhereted_presenter.superclass.should == super_presenter
      inhereted_presenter.superclass.superclass.should == Guise::Presenter
   end

   it "should be able to access defined mappings" do
      presenter = Guise::Presenter.define {}
      presenter.mappings.should == []
   end

   it "should add a mapping for each call to #map" do
      user_presenter.mappings.map(&:name).should == [:id, :name, :email]
   end

   it "should inherit all mappings of it's superclass without modifying them" do
      admin_presenter = user_presenter.define do
         maps :role
      end

      user_presenter.mappings.map(&:name).should == [:id, :name, :email]
      admin_presenter.mappings.map(&:name).should == [:id, :name, :email, :role]
   end

   it "should be able to wrap an object and produce a hash of it's presentation" do
      user = OpenStruct.new(:id => 42, :name => "foobar", :role => "admin")

      user_presenter.new(user).to_hash.should == {
         :id => 42,
         :name => "foobar",
         :login => nil
      }
   end

   it "should be able to wrap an object and assign attributes from a hash" do
      user = OpenStruct.new

      user_presenter.new(user).attributes = {:id => 42, :name => "foobar"}

      user.id.should == 42
      user.name.should == "foobar"
   end

   it "should respond to any attribute defined on it" do
      user_presenter.new(OpenStruct.new).should respond_to :login
   end

   it "should retrieve the value of the attribute when called" do
      user = OpenStruct.new(:email => "foo@example.com")

      user_presenter.new(user).login.should == "foo@example.com"
   end
end