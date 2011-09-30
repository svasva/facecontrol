# encoding: utf-8
require 'spec_helper'

describe Place do

	it 'init with default actions' do
		p = Place.new
		p.enter_action.should_not == nil
		p.stay_action.should_not == nil
		p.leave_action.should_not == nil
	end


	context 'parse table' do
		before(:all) do
			@bo = Factory.create :blue_oyster
			@table = [
			[@bo.id, 'Бар \'Голубая устрица2\'', 'всем известное место2',
				'http://pic3.ru',33,45,'v_urls',
				6, 5, 4, 3, 2, 1,
				-100,200, 50, 500,
				16, 17, 16, 15, 14, 13, 12, 11],
			[nil,'Рюмочная \'Второе дыхание\'', 'спасение изнурённому человеку',
				'http://pic2.ru',31, 42, 'v_urls2',
				4, 5, 6, 7, 8, 9, 10,
				100, 100, 100, -500,
				10, 11, 12, 13, 14, 15, 16]]
		end

		it 'changes Place count' do
			expect do
				Place.parse_table @table
	      	end.to change {Place.count}.from(1).to(2)
		end
		
		it 'writes attributes to updated places' do
			Place.parse_table @table
			@bo.reload
			@bo.name.should == 'Бар \'Голубая устрица2\''
			@bo.description.should == 'всем известное место2'
			@bo.picture_url.should == 'http://pic3.ru'
			@bo.map_x.should == 33
			@bo.map_y.should == 45
			@bo.video_urls.should == 'v_urls'
		end


		it 'creates all actions for updated enteries' do
			Place.parse_table @table
			@bo.reload
			@bo.actions.count.should == 3
			
			@bo.enter_action.should_not == nil
			@bo.stay_action.should_not == nil
			@bo.leave_action.should_not == nil
		end
		
		let(:new_place) {Place.last}

		it 'writes actions to new enteries' do
			Place.parse_table @table

			new_place.actions.count.should == 3
			new_place.enter_action.should_not == nil
			new_place.leave_action.should_not == nil
			new_place.stay_action.should_not == nil
		end

		it 'stay action os child of enter action' do
			Place.parse_table @table
			new_place.stay_action.parent.should == new_place.enter_action
		end

		it 'writes attributes to new places' do
			Place.parse_table @table		
			new_place.name.should == 'Рюмочная \'Второе дыхание\''
			new_place.description.should == 'спасение изнурённому человеку'
			new_place.map_x.should == 31
			new_place.map_y.should == 42
			new_place.video_urls.should == 'v_urls2'
		end

		it 'writes attributes to enter_action of new enteries' do
			Place.parse_table @table
			new_place.stay_action.delta_energy.should == 100
			new_place.stay_action.delta_glory.should == 100
			new_place.stay_action.delta_drive.should == 100
			new_place.stay_action.delta_wear.should == -500
			new_place.stay_action.repeat.should == true
			new_place.stay_action.delay.should == 60
		end

		it 'writes attributes to conditions of enter_action' do
			Place.parse_table @table
			enter_condition = new_place.enter_action.conditions.find_by_name 'enter_condition'
			enter_condition.level.should == 4
			enter_condition.energy.should == 5
			enter_condition.drive.should == 6
			enter_condition.glory.should == 7
			enter_condition.real_glory.should == 8
			enter_condition.glamour.should == 9
			enter_condition.money.should == 10
			enter_condition.operator.should == '>='

			view_condition = new_place.enter_action.conditions.find_by_name 'visible_condition'
			view_condition.level.should == 10
			view_condition.energy.should == 11
			view_condition.drive.should == 12
			view_condition.glory.should == 13
			view_condition.real_glory.should == 14
			view_condition.glamour.should == 15
			view_condition.money.should == 16
			view_condition.operator.should == '>='
		end

		it 'writes attributes to conditions of stay_action' do
			Place.parse_table @table
			stay_condition = new_place.stay_action.conditions.find_by_name 'stay_condition'
			stay_condition.level.should == 0
			stay_condition.energy.should == 0
			stay_condition.drive.should == 0
			stay_condition.glory.should == 0
			stay_condition.real_glory.should == 0
			stay_condition.glamour.should == 0
			stay_condition.money.should == 0
			stay_condition.operator.should == '>='

		end
	end
end
