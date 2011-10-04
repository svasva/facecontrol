# encoding: utf-8

module Models
  module Place
    module CsvExchange
      extend ActiveSupport::Concern
       
      module ClassMethods
        include Models::CsvParseCommons 
        def parse_table(table)
          parse_generic_table(table) do |record, row|
            enter_condition = Condition.new({:name => :enter_condition})
            view_condition = Condition.new({:name => :visible_condition})
            stay_condition = Condition.new({:name => :stay_condition})

            record.name,  
            record.description, 
            record.picture_url,
            record.map_x,
            record.map_y,
            record.video_urls,
            enter_condition.level ,
            enter_condition.energy,
            enter_condition.drive,
            enter_condition.glory,
            enter_condition.real_glory,
            enter_condition.glamour,
            enter_condition.money,
            enter_condition.social_friends_count,

            record.stay_action.delta_energy,
            record.stay_action.delta_glory,
            record.stay_action.delta_drive,
            record.stay_action.delta_wear,

            view_condition.level,
            view_condition.energy,
            view_condition.drive,
            view_condition.glory,
            view_condition.real_glory,
            view_condition.glamour,
            view_condition.money,
            view_condition.social_friends_count = row[1..-1]

            record.stay_action.repeat = true
            record.stay_action.delay = 60

            stay_condition.level,
            stay_condition.energy,
            stay_condition.drive,
            stay_condition.glory,
            stay_condition.real_glory,
            stay_condition.glamour,
            stay_condition.money = [0,0,0,0,0,0,0]

            record.enter_action.conditions = [enter_condition, view_condition]
            record.stay_action.conditions = [stay_condition]
            record.stay_action.parent = record.enter_action

          end
        end


        require "csv"
        def parse_csv(params)

          data = CSV.read(params[:file].tempfile, {:encoding => "utf-8"})[2..-1]
          self.parse_table data
        end

        def generate_csv
          CSV.generate do |c|
            self.all.each do |p|
              c << p.table_row 
            end
          end
        end

      end

      module InstanceMethods
        def table_row
          enter_condition = self.enter_action.conditions.find_by_name "enter_condition"
          view_condition = self.enter_action.conditions.find_by_name "visible_condition"
          [ self.id,
            self.name,  
            self.description, 
            self.picture_url,
            self.map_x,
            self.map_y,
            self.video_urls,
            enter_condition.level ,
            enter_condition.energy,
            enter_condition.drive,
            enter_condition.glory,
            enter_condition.real_glory,
            enter_condition.glamour,
            enter_condition.money,
            enter_condition.social_friends_count,

            self.stay_action.delta_energy,
            self.stay_action.delta_glory,
            self.stay_action.delta_drive,
            self.stay_action.delta_wear,

            view_condition.level,
            view_condition.energy,
            view_condition.drive,
            view_condition.glory,
            view_condition.real_glory,
            view_condition.glamour,
            view_condition.money,
            view_condition.social_friends_count ] 
        end
      end
    end
  end
end
