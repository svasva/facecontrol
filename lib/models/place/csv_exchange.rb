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

            record.enter_action.delta_energy,
            record.enter_action.delta_glory,
            record.enter_action.delta_drive,
            record.enter_action.delta_wear,

            view_condition.level,
            view_condition.energy,
            view_condition.drive,
            view_condition.glory,
            view_condition.real_glory,
            view_condition.glamour,
            view_condition.money = row[1..-1]

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

        def generate_table
          self.all.map do |p|
            [ p.id,
              p.name,
              p.description,
              p.map_x,
              p.map_y,
              p.video_urls,
              p.enter_action.conditions.first.glory,
              p.enter_action.conditions.first.real_glory,
              p.enter_action.conditions.first.glamour,
              p.enter_action.conditions.first.energy,
              p.enter_action.delta_energy,
              p.enter_action.delta_glory,
              p.enter_action.delta_drive,
              p.enter_action.delta_wear] 
          end
        end

        require "csv"
        def parse_csv(params)

          data = CSV.read(params[:file].tempfile, {:encoding => "utf-8"})[2..-1]
          self.parse_table data
        end
      end
    end
  end
end
