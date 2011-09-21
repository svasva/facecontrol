# encoding: utf-8

module Models
  module Item
    module CsvExchange
      extend ActiveSupport::Concern
       
      module ClassMethods
        include Models::CsvParseCommons 

       
        def parse_drinks_table(table)
          parse_generic_table(table) do |record, row|
            record.picture_url = row[1]
            record.name = row[2]
            record.description = row[3]
            record.buy_action.delta_energy = row[4]
            record.gift_action.delta_energy = row[4]
            record.buy_action.delta_money = row[5]
            record.gift_action.delta_money = row[5]
            record.gift_action.delta_drive = row[6]

            record.buy_action.delta_energy = record.buy_action.delta_energy + row[7]
            record.use_action.delta_energy = row[7]
            record.buy_action.delta_drive = record.buy_action.delta_drive + row[8]
            record.use_action.delta_drive = row[8]
            record.buy_action.delta_glory = row[9]
            record.gift_action.delta_glory = row[9]
            record.buy_action.contest_rating = row[10]
            record.gift_action.contest_rating = row[10]
          end
        end

        require "csv"
        def parse_drinks_csv(params)

          data = CSV.read(params[:file].tempfile, {:encoding => "utf-8"})[2..-1]
          self.parse_drinks_table data
        end

      end
    end
  end
end
