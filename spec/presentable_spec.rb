require 'spec_helper'

describe Guise::Presentable do
   subject { Guise::Presentable }

   let(:base_class) { Class.new }
   let(:mixed_class) { base_class.send(:include, subject); base_class }

   let(:user_model) do
      mixed_class.define_presentation :user do
         maps :id
         maps :name
      end

      mixed_class.send(:attr_accessor, :id, :name)

      mixed_class
   end

   let(:user) do
      user = user_model.new
      user.id = 42
      user.name = "foo"
      user
   end

   it "should define #guise_presentations on the class that mixes it in" do
      base_class.should_not respond_to :guise_presentations
      base_class.send(:include, subject)
      base_class.should respond_to :guise_presentations
   end

   it "should return an empty hash by default" do
      mixed_class.guise_presentations.should == {}
   end

   it "should allow defining a presentation with #define_presentation" do
      presentations = user_model.guise_presentations

      presentations.keys.should == [:user]
      presentations[:user].superclass.should == Guise::Presenter
      presentations[:user].should have(2).mappings
   end

   it "should define :to_presentation on the instance level" do
      user_model.new.should respond_to :to_presentation
   end

   it "should return the presentation specified" do
      user.to_presentation(:user).should == {
         :id => 42,
         :name => "foo"
      }
   end

   it "should respond to the #to_xyz_presentation methods" do
      user.should respond_to :to_user_presentation
   end

   it "should use method_missing to support #to_xyz_presentation" do
      user.to_user_presentation.should == {
         :id => 42,
         :name => "foo"
      }
   end

   it "should be serializable from a presentation" do
      user = user_model.new_from_presentation(:user, :id => 99, :name => "bar")
      user.id.should == 99
      user.name.should == "bar"
   end

   it "should respond to #new_from_xyz_presentation" do
      user_model.should respond_to :new_from_user_presentation
   end

   it "should use method_missing to support #new_from_xyz_presentation" do
      user = user_model.new_from_user_presentation(:id => 80, :name => "baz")
      user.id.should == 80
      user.name.should == "baz"
   end
end