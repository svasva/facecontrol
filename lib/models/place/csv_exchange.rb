# encoding: utf-8

module Models
  module Place
    module CsvExchange
      extend ActiveSupport::Concern
       
      module ClassMethods
       
        def parse_table(table)
          new_enteries, update_enteries = table.partition{|e| e[0].blank? }
          #TODO check all id's for existence
          
          update_enteries.each do |e|
            record = assign_attributes(self.find(e[0]), e) #Find by ID
            record.save
          end 

          new_enteries.each do |e|
            record = assign_attributes(self.new, e)
            record.save
          end
        end

        def generate_table
          self.all.map do |p|
            [ p.id,
              p.name,
              p.description,
              p.picture_url,
              p.enter_action.conditions.first.glory,
              p.enter_action.conditions.first.real_glory,
              p.enter_action.conditions.first.glamour,
              p.enter_action.conditions.first.energy,
              p.enter_action.delta_energy,
              p.enter_action.delta_glory,
              p.enter_action.delta_drive,
              p.enter_action.delta_glamour] 
          end
        end

        require "csv"
        def parse_csv(params)

          data = CSV.read(params[:file].tempfile)[2..-1]
          self.parse_table data
        end

        private
        def assign_attributes(record, row)
          record.name = row[1]  
          record.description = row[2] 
          record.picture_url = row[3]
          enter_condition = record.enter_action.conditions.first
          enter_condition.glory = row[4]
          enter_condition.real_glory = row[5]
          enter_condition.glamour = row[6]
          enter_condition.energy = row[7]
          record.enter_action.delta_energy = row[8]
          record.enter_action.delta_glory = row[9]
          record.enter_action.delta_drive = row[10]
          record.enter_action.delta_glamour = row[11]
          record
        end
      end
    end
  end
end
