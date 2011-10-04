# encoding: utf-8
require 'spec_helper'

describe GameAction do
  context "creates default condition" do
    it "creates default condition" do
      a = GameAction.create({
       :delta_energy => -1,
       :delta_money => -2,
       :delta_drive => -3,
       :delta_glory => -4,
       :delta_real_glory => -5})
      default_condition = a.conditions.find_by_name('default_condition')
      default_condition.energy.should == 1  
      default_condition.money.should == 2
      default_condition.drive.should == 3
      default_condition.glory.should == 4
      default_condition.real_glory.should == 5 
    end
    it 'doen\'t crreates condition, not needed' do
      a = GameAction.create({
       :delta_energy => 1,
       :delta_money => 2,
       :delta_drive => 3,
       :delta_glory => 4,
       :delta_real_glory => 5})
      a.conditions.should == []
    end

     it 'should not raise' do
      a = GameAction.create
      a.conditions.should == []
    end
  end
end
