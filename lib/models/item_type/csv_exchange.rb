# encoding: utf-8

module Models
  module ItemType
    module CsvExchange
      extend ActiveSupport::Concern
       
      module ClassMethods
        include Models::CsvParseCommons 

       
        def parse_types_table(table)
          parse_generic_table(table) do |record, row|
            record.name =         row[1]
            record.description =  row[2]
            record.wearable =     row[3]
            record.giftable =     row[4]
            record.unique =       row[5]
            record.wear_limit =   row[6]
            record.own_limit =    row[7]
            record.exclusive =    row[8]
            record.usable =       row[9]
          end
        end

        def bool(val)
          ActiveRecord::ConnectionAdapters::Column.value_to_boolean(val)
        end

        require "csv"
        def parse_csv(params)

          data = CSV.read(params[:file].tempfile, {:encoding => "utf-8"})[2..-1]
          self.parse_types_table data
        end

      end
    end
  end
end
