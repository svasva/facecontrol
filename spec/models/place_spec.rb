# encoding: utf-8
require 'spec_helper'

describe Place do

	it "init woth default actions" do
		p = Place.new
		p.enter_action.should_not == nil
		p.stay_action.should_not == nil
		p.leave_action.should_not == nil
	end


	context "parse table" do
		before(:all) do
			@bo = Factory.create :blue_oyster
			@table = [
			[@bo.id, "Бар 'Голубая устрица2'", "всем известное место2",
				"http://pic3.ru", 4, 3, 2, 1, -100,200, 50, 500],
			[nil,"Рюмочная 'Второе дыхание'", "спасение изнурённому человеку",
				"http://pic2.ru", 5, 6, 7, 8, 100, 100, 100, -500]]
		end

		it "chages Place count" do
			expect do
				Place.parse_table @table
	      	end.to change {Place.count}.from(1).to(2)
		end
		
		it "writes attributes to updated places" do
			Place.parse_table @table
			@bo.reload
			@bo.name.should == "Бар 'Голубая устрица2'"
			@bo.description.should == "всем известное место2"
			@bo.picture_url.should == "http://pic3.ru"
		end


		it "creates all actions for updated enteries" do
			Place.parse_table @table
			@bo.reload
			@bo.actions.count.should == 3
			
			@bo.enter_action.should_not == nil
			@bo.stay_action.should_not == nil
			@bo.leave_action.should_not == nil
		end
		
		let(:new_place) {Place.last}

		it "writes actions to new enteries" do
			Place.parse_table @table

			new_place.actions.count.should == 3
			new_place.enter_action.should_not == nil
			new_place.leave_action.should_not == nil
			new_place.stay_action.should_not == nil
		end

		it "writes attributes to new places" do
			Place.parse_table @table		
			new_place.name.should == "Рюмочная 'Второе дыхание'"
			new_place.description.should == "спасение изнурённому человеку"
			new_place.picture_url.should == "http://pic2.ru"
		end

		it "writes attributes to enter_action of new enteries" do
			Place.parse_table @table
			new_place.enter_action.delta_energy.should == 100
			new_place.enter_action.delta_glory.should == 100
			new_place.enter_action.delta_drive.should == 100
			new_place.enter_action.delta_glamour.should == -500
		end

		it "writes attributes to conditions of enter_action" do
			Place.parse_table @table
			enter_condition = new_place.enter_action.conditions.first
			enter_condition.glory.should == 5
			enter_condition.real_glory.should == 6
			enter_condition.glamour.should == 7
			enter_condition.energy.should == 8
		end
	end
end