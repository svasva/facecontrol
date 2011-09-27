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
            record.buy_action.delta_energy = -(row[4].to_i)
            record.gift_action.delta_energy = -(row[4].to_i)
            record.buy_action.delta_money = -(row[5].to_i)
            record.gift_action.delta_money = -(row[5].to_i)
            record.gift_action.delta_drive = -(row[6].to_i)

            record.buy_action.delta_energy = record.buy_action.delta_energy + row[7].to_i
            record.use_action.delta_energy = row[7]
            record.buy_action.delta_drive = record.buy_action.delta_drive + row[8].to_i
            record.use_action.delta_drive = row[8]
            record.buy_action.delta_glory = row[9]
            record.gift_action.delta_glory = row[9]
            record.buy_action.contest_rating = row[10]
            record.gift_action.contest_rating = row[10]
            record.set_type_by_name(row[11])
          end
        end

        def parse_gifts_table(table)
          parse_generic_table(table) do |record, row|
            record.picture_url = row[1]
            record.name = row[2]
            record.description = row[3]
            record.gift_action.delta_energy = -(row[4].to_i)
            record.gift_action.delta_money = -(row[5].to_i)
            record.gift_action.contest_rating = row[6]
            record.set_type_by_name(row[7])
          end
        end

        def parse_clothes_table(table)
          parse_generic_table(table) do |record, row|
            record.picture_url = row[1]
            record.name = row[2]
            record.description = row[3]
            record.sex = (row[4] == "М") ? 1 : 0

            record.buy_action.delta_energy = -(row[5].to_i)
            record.buy_action.delta_money = -(row[6].to_i)

            record.glamour = row[7]
            record.buy_action.contest_rating = row[8]
            record.set_type_by_name(row[9])
          end
        end


        require "csv"
        def parse_drinks_csv(params)

          data = CSV.read(params[:file].tempfile, {:encoding => "utf-8"})[2..-1]
          self.parse_drinks_table data
        end

        def parse_gifts_csv(params)

          data = CSV.read(params[:file].tempfile, {:encoding => "utf-8"})[2..-1]
          self.parse_gifts_table data
        end
        
        def parse_clothes_csv(params)

          data = CSV.read(params[:file].tempfile, {:encoding => "utf-8"})[2..-1]
          self.parse_clothes_table data
        end

      end
    end
  end
end
