# encoding: utf-8

module Models
  module Item
    module CsvExchange
      extend ActiveSupport::Concern
       
      module ClassMethods
        include Models::CsvParseCommons 

       
        def parse_drinks_table(table)
          parse_generic_table(table) do |record, row|
            record.set_type_by_name(row[11])

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
            record.gift_action.need_target = true
          end
        end

        def parse_gifts_table(table)
          parse_generic_table(table) do |record, row|
            record.set_type_by_name(row[8])

            record.picture_url = row[1]
            record.name = row[2]
            record.description = row[3]
            record.gift_action.delta_energy = -(row[4].to_i)
            record.gift_action.delta_money = -(row[5].to_i)
            record.gift_action.contest_rating = row[6]
            record.gift_action.need_target = true
            record.ttl = row[7]
          end
        end

        def parse_clothes_table(table)
          parse_generic_table(table) do |record, row|
            record.set_type_by_name(row[9])

            record.picture_url = row[1]
            record.name = row[2]
            record.description = row[3]
            record.sex = (row[4] == "М") ? 1 : 0

            record.buy_action.delta_energy = -(row[5].to_i)
            record.buy_action.delta_money = -(row[6].to_i)

            record.glamour = row[7]
            record.buy_action.contest_rating = row[8]
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



        def generate_csv(type_names, row_method)
          CSV.generate do |c|
            self.by_type_names(type_names) do |p|
              c << p.method(row_method).call
            end
          end
        end

        def generate_drink_csv
          generate_csv(["cocktail", "drink", "energy"], :drink_row)
        end

        def generate_gift_csv
          generate_csv("gift", :gift_row)
        end

        def generate_cloth_csv
          generate_csv("clothes", :cloth_row)
        end        
      end

      module InstanceMethods
        def drink_row
          [ self.id,
            self.picture_url,
            self.name,
            self.description,
            -self.gift_action.delta_energy,
            -self.gift_action.delta_money,
            -self.gift_action.delta_drive,

            self.use_action.delta_energy,
            self.use_action.delta_drive,
            self.gift_action.delta_glory,
            self.gift_action.contest_rating,
            self.item_type.name ] 
        end
        def gift_row
          [ self.picture_url,
            self.name,
            self.description,
            -self.gift_action.delta_energy,
            -self.gift_action.delta_money,
            self.gift_action.contest_rating,
            self.gift_action.need_target,
            self.ttl,
            self.item_type.name]
        end
        def cloth_row
          [ self.picture_url,
            self.name,
            self.description,
            (self.sex ? 'М' : 'Ж'),
            -self.buy_action.delta_energy,
            -self.buy_action.delta_money,
            self.glamour,
            self.buy_action.contest_rating,
            self.item_type.name]
        end
      end

    end
  end
end
