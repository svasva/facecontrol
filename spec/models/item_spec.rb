# encoding: utf-8
require 'spec_helper'

describe Item do

  it "init with default actions" do
    i = Item.new
    i.buy_action.should_not == nil
    i.use_action.should_not == nil
    i.gift_action.should_not == nil
  end


  context "parse drinks table" do
    before(:all) do
      Factory.create :drink_type
      @table = [
      [nil,"http://pic2.ru", "Шот 'Огненная собака'", "Самбука и красный перец",
        -5, 0, -5, 6, 7, 8, 100],
      [nil,"http://pic3.ru", "Jim Beam", "односолодовый и фкусный",
        0, -20, -5, 7, 8, 9, 200]]
    end

    it "changes Items count" do
      expect do
        Item.parse_drinks_table @table
          end.to change {Item.count}.from(0).to(2)
    end
    
    let(:new_drink) {Item.last}

    it "writes actions to new enteries" do
      Item.parse_drinks_table @table

      new_drink.actions.count.should == 3
      new_drink.buy_action.should_not == nil
      new_drink.gift_action.should_not == nil
      new_drink.use_action.should_not == nil
    end

    it "writes attributes to new places" do
      Item.parse_drinks_table @table    
      new_drink.name.should == "Jim Beam"
      new_drink.description.should == "односолодовый и фкусный"
      new_drink.picture_url.should == "http://pic3.ru"
      new_drink.item_type.name == "drink"

    end

    it "writes attributes to buy_action of new enteries" do
      Item.parse_drinks_table @table
      new_drink.buy_action.delta_energy.should == 7
      new_drink.buy_action.delta_money.should == -20
      new_drink.buy_action.delta_drive.should == 8
      new_drink.buy_action.delta_glory.should == 9
      new_drink.buy_action.contest_rating.should == 200
    end

    it "writes attributes to conditions of use_action" do
      Item.parse_drinks_table @table
      new_drink.use_action.delta_energy.should == 7
      new_drink.use_action.delta_money.should == 0
      new_drink.use_action.delta_drive.should == 8
      new_drink.use_action.delta_glory.should == 0
      new_drink.use_action.contest_rating.should == 0
    end

    it "writes attributes to conditions of gift_action" do
      Item.parse_drinks_table @table
      new_drink.gift_action.delta_energy.should == 0
      new_drink.gift_action.delta_money.should == -20
      new_drink.gift_action.delta_drive.should == -5
      new_drink.gift_action.delta_glory.should == 9
      new_drink.gift_action.contest_rating.should == 200
    end

  end
end
