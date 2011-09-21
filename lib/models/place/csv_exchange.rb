# encoding: utf-8

module Models
  module Place
    module CsvExchange
      extend ActiveSupport::Concern
       
      module ClassMethods
        include Models::CsvParseCommons 
        def parse_table(table)
          parse_generic_table(table) do |record, row|
            enter_condition = record.enter_action.conditions.first

            record.name,  
            record.description, 
            record.picture_url,
            record.map_x,
            record.map_y,
            record.video_urls,
            enter_condition.glory,
            enter_condition.real_glory,
            enter_condition.glamour,
            enter_condition.energy,
            record.enter_action.delta_energy,
            record.enter_action.delta_glory,
            record.enter_action.delta_drive,
            record.enter_action.delta_wear = row[1..-1]
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
