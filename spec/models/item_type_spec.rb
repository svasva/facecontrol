# encoding: utf-8
require 'spec_helper'

describe ItemType do

  context "parse types table" do
    before(:all) do
      @table = [
      [nil,"cocktail", "Коктейль", "FALSE","TRUE", "FALSE", 0, 0, "FALSE", "TRUE"]]
    end

    it "changes ItemTypes count" do
      expect do
      ItemType.parse_types_table @table
        end.to change {ItemType.count}.from(0).to(1)
    end
    
    let(:new_type) {ItemType.last} 

    it "writes attributes to new places" do
      ItemType.parse_types_table @table    
      new_type.name.should == "cocktail"
      new_type.description.should == "Коктейль"
      new_type.wearable.should == false
      new_type.giftable.should == true
      new_type.unique.should == false
      new_type.wear_limit.should == 0
      new_type.own_limit.should == 0
      new_type.exclusive.should == false
      new_type.usable.should == true
    end

  end
end
